#!/bin/sh
# ===================================================================================
# 用于在 docker 容器中的 springboot 应用
#
# 使用说明:
#    # 运行 java 应用:
#    ./run-java.sh <应用参数>
#
#
#
#
# Source and Documentation can be found
# at https://github.com/fabric8io-images/run-java-sh
#
# 脚本中的环境变量:
#
# JAVA_OPTIONS: 检测已经设置的配置
# JAVA_MAX_MEM_RATIO: 计算最大内存的比例, 数值为百分比.
#                     例如设置为 50 则表示 '-Xmx'=CONTAINER_MAX_MEMORY * 50%
#
#                     当容器可用内存小于300M时默认为 "25" 否则为 "50".
#                     最好根据应用的实际情况进行配置
#                     更多相关资料请参阅 -->
#                             https://youtu.be/Vt4G-pHXfs4
#                             https://www.youtube.com/watch?v=w1rZOY5gbvk
#                             https://vimeo.com/album/4133413/video/181900266
# 注意JVM堆内存只是一小部分. 还有许多其它的内存区域比如(metadata(java8+), thread, code cache, ...)
# 因此如果容器因为 OOM 被杀掉，需要分析相关配置
# JAVA_INIT_MEM_RATIO: Xms 的比例, 数值为百分比. 默认没设置
#
#
# 以下参数会传递给java 应用:
#
# CONTAINER_MAX_MEMORY: 容器可用的最大内存
# MAX_CORE_LIMIT: 容器可用的 cpu 数
# 出错则退出执行(需要系统支持)
(set -o | grep -q pipefail) && set -o pipefail

# 出错或使用未定义的变量时退出执行
set -eu

# 保存脚本全局参数
ARGS="$@"

# ksh 的本地变量定义不一样要用 typeset
if [ -n "${KSH_VERSION:-}" ]; then
  alias local=typeset
fi

# Error is indicated with a prefix in the return value 错误信息
check_error() {
  local error_msg="$1"
  if echo "${error_msg}" | grep -q "^ERROR:"; then
    echo "${error_msg}"
    exit 1
  fi
}

# 脚本所在的绝对路径
script_dir() {
  # Default is current directory
  local dir=$(dirname "$0")
  local full_dir=$(cd "${dir}" && pwd)
  echo ${full_dir}
}

# 基于 awk 的常用公式
calc() {
  local formula="$1"
  shift
  echo "$@" | awk '
    function ceil(x) {
      return x % 1 ? int(x) + 1 : x
    }
    function log2(x) {
      return log(x)/log(2)
    }
    function max2(x, y) {
      return x > y ? x : y
    }
    function round(x) {
      return int(x + 0.5)
    }
    {print '"int(${formula})"'}
  '
}

# 基于 cgroup limits, 获取可用 cpu 核数
core_limit() {
  local cpu_period_file="/sys/fs/cgroup/cpu/cpu.cfs_period_us"
  local cpu_quota_file="/sys/fs/cgroup/cpu/cpu.cfs_quota_us"
  if [ -r "${cpu_period_file}" ]; then
    local cpu_period="$(cat ${cpu_period_file})"

    if [ -r "${cpu_quota_file}" ]; then
      local cpu_quota="$(cat ${cpu_quota_file})"
      # cfs_quota_us == -1 --> no restrictions
      if [ ${cpu_quota:-0} -ne -1 ]; then
        echo $(calc 'ceil($1/$2)' "${cpu_quota}" "${cpu_period}")
      fi
    fi
  fi
}

# 基于 cgroup limits, 获取可用 内存
max_memory() {
  # High number which is the max limit until which memory is supposed to be
  # unbounded.
  local mem_file="/sys/fs/cgroup/memory/memory.limit_in_bytes"
  if [ -r "${mem_file}" ]; then
    local max_mem_cgroup="$(cat ${mem_file})"
    local max_mem_meminfo_kb="$(cat /proc/meminfo | awk '/MemTotal/ {print $2}')"
    local max_mem_meminfo="$(expr $max_mem_meminfo_kb \* 1024)"
    if [ ${max_mem_cgroup:-0} != -1 ] && [ ${max_mem_cgroup:-0} -lt ${max_mem_meminfo:-0} ]
    then
      echo "${max_mem_cgroup}"
    fi
  fi
}

init_limit_env_vars() {
  # Read in container limits and export the as environment variables
  local core_limit="$(core_limit)"
  if [ -n "${core_limit}" ]; then
    export CONTAINER_CORE_LIMIT="${core_limit}"
  fi

  local mem_limit="$(max_memory)"
  if [ -n "${mem_limit}" ]; then
    export CONTAINER_MAX_MEMORY="${mem_limit}"
  fi
}

load_env() {
  local script_dir="$1"

  # Configuration stuff is read from this file
  local run_env_sh="run-env.sh"

  # Load default default config
  if [ -f "${script_dir}/${run_env_sh}" ]; then
    . "${script_dir}/${run_env_sh}"
  fi
}
# ==========================================================================

memory_options() {
  echo "$(calc_init_memory) $(calc_max_memory)"
  return
}

# Check for memory options and set max heap size if needed
calc_max_memory() {
  # Check whether -Xmx is already given in JAVA_OPTIONS
  if echo "${JAVA_OPTIONS:-}" | grep -q -- "-Xmx"; then
    return
  fi

  if [ -z "${CONTAINER_MAX_MEMORY:-}" ]; then
    return
  fi

  # Check for the 'real memory size' and calculate Xmx from the ratio
  if [ -n "${JAVA_MAX_MEM_RATIO:-}" ]; then
    if [ "${JAVA_MAX_MEM_RATIO}" -eq 0 ]; then
      # Explicitely switched off
      return
    fi
    calc_mem_opt "${CONTAINER_MAX_MEMORY}" "${JAVA_MAX_MEM_RATIO}" "mx"
  elif [ "${CONTAINER_MAX_MEMORY}" -le 314572800 ]; then
    # Restore the one-fourth default heap size instead of the one-half below 300MB threshold
    # See https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html#default_heap_size
    calc_mem_opt "${CONTAINER_MAX_MEMORY}" "25" "mx"
  else
    calc_mem_opt "${CONTAINER_MAX_MEMORY}" "50" "mx"
  fi
}

# Check for memory options and set initial heap size if requested
calc_init_memory() {
  # Check whether -Xms is already given in JAVA_OPTIONS.
  if echo "${JAVA_OPTIONS:-}" | grep -q -- "-Xms"; then
    return
  fi
  # echo $CONTAINER_MAX_MEMORY
  # Check if value set
  if [ -z "${JAVA_INIT_MEM_RATIO:-}" ] || [ -z "${CONTAINER_MAX_MEMORY:-}" ] || [ "${JAVA_INIT_MEM_RATIO}" -eq 0 ]; then
    return
  fi

  # Calculate Xms from the ratio given
  calc_mem_opt "${CONTAINER_MAX_MEMORY}" "${JAVA_INIT_MEM_RATIO}" "ms"
}

calc_mem_opt() {
  local max_mem="$1"
  local fraction="$2"
  local mem_opt="$3"

  local val=$(calc 'round($1*$2/100/1048576)' "${max_mem}" "${fraction}")
  echo "-X${mem_opt}${val}m"
}

c2_disabled() {
  if [ -n "${CONTAINER_MAX_MEMORY:-}" ]; then
    # Disable C2 compiler when container memory <=300MB
    if [ "${CONTAINER_MAX_MEMORY}" -le 314572800 ]; then
      echo true
      return
    fi
  fi
  echo false
}

jit_options() {
  # Check whether -XX:TieredStopAtLevel is already given in JAVA_OPTIONS
  if echo "${JAVA_OPTIONS:-}" | grep -q -- "-XX:TieredStopAtLevel"; then
    return
  fi
  if [ $(c2_disabled) = true ]; then
    echo "-XX:TieredStopAtLevel=1"
  fi
}

# Switch on diagnostics except when switched off
diagnostics_options() {
  if [ -n "${JAVA_DIAGNOSTICS:-}" ]; then
    echo "-XX:NativeMemoryTracking=summary -XX:+PrintGC -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:+UnlockDiagnosticVMOptions"
  fi
}

# Replicate thread ergonomics for tiered compilation.
# This could ideally be skipped when tiered compilation is disabled.
# The algorithm is taken from:
# OpenJDK / jdk8u / jdk8u / hotspot
# src/share/vm/runtime/advancedThresholdPolicy.cpp
ci_compiler_count() {
  local core_limit="$1"
  local log_cpu=$(calc 'log2($1)' "$core_limit")
  local loglog_cpu=$(calc 'log2(max2($1,1))' "$log_cpu")
  local count=$(calc 'max2($1*$2,1)*3/2' "$log_cpu" "$loglog_cpu")
  local c1_count=$(calc 'max2($1/3,1)' "$count")
  local c2_count=$(calc 'max2($1-$2,1)' "$count" "$c1_count")
  [ $(c2_disabled) = true ] && echo "$c1_count" || echo $(calc '$1+$2' "$c1_count" "$c2_count")
}

cpu_options() {
  local core_limit="${JAVA_CORE_LIMIT:-}"
  if [ "$core_limit" = "0" ]; then
    return
  fi

  if [ -n "${CONTAINER_CORE_LIMIT:-}" ]; then
    if [ -z ${core_limit} ]; then
      core_limit="${CONTAINER_CORE_LIMIT}"
    fi
    echo "-XX:ParallelGCThreads=${core_limit} " \
         "-XX:ConcGCThreads=${core_limit} " \
         "-Djava.util.concurrent.ForkJoinPool.common.parallelism=${core_limit} " \
         "-XX:CICompilerCount=$(ci_compiler_count $core_limit)"
  fi
}

#-XX:MinHeapFreeRatio=20  These parameters tell the heap to shrink aggressively and to grow conservatively.
#-XX:MaxHeapFreeRatio=40  Thereby optimizing the amount of memory available to the operating system.
heap_ratio() {
  echo "-XX:MinHeapFreeRatio=20 -XX:MaxHeapFreeRatio=40"
}

# These parameters are necessary when running parallel GC if you want to use the Min and Max Heap Free ratios.
# Skip setting gc_options if any other GC is set in JAVA_OPTIONS.
# -XX:GCTimeRatio=4
# -XX:AdaptiveSizePolicyWeight=90
gc_options() {
    if echo "${JAVA_OPTIONS:-}" | grep -q -- "-XX:.*Use.*GC"; then
      return
    fi
    local opts="-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 $(heap_ratio)"
    if [ -z "${JAVA_MAJOR_VERSION:-}" ] || [ "${JAVA_MAJOR_VERSION:-}" != "7" ]; then
      opts="${opts} -XX:+ExitOnOutOfMemoryError"
    fi
    echo $opts
}

java_default_options() {
  # Echo options, trimming trailing and multiple spaces
  echo "$(memory_options) $(jit_options) $(diagnostics_options) $(cpu_options) $(gc_options)" | awk '$1=$1'

}

# ==============================================================================

# Combine all java options
java_options() {
  # Normalize spaces with awk (i.e. trim and elimate double spaces)
  # See e.g. https://www.physicsforums.com/threads/awk-1-1-1-file-txt.658865/ for an explanation
  # of this awk idiom
  echo "${JAVA_OPTIONS:-}  $(java_default_options)" | awk '$1=$1'
}

# Checks if a flag is present in the arguments.
hasflag() {
    local filters="$@"
    for var in $ARGS; do
        for filter in $filters; do
          if [ "$var" = "$filter" ]; then
              echo 'true'
              return
          fi
        done
    done
}


# Start JVM
run() {
  # Initialize environment
  load_env $(script_dir)

  # Don't put ${args} in quotes, otherwise it would be interpreted as a single arg.
  # However it could be two args (see above). zsh doesn't like this btw, but zsh is not
  # supported anyway.
  echo exec  java $(java_options) /app.jar $@
  exec  java $(java_options) -Djava.security.egd=file:/dev/./urandom -jar /app.jar $@
}
# =============================================================================
# Fire up

# Set env vars reflecting limits
init_limit_env_vars
run $@
