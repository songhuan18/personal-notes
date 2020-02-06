#### JVM参数
参数名称 | 含义 | 默认值 | 示例 | 说明
--- | --- | --- | --- | --- | ---
-Xms | 初始堆大小 | 物理内存的1/64(<1GB) ，Server端JVM最好将-Xms和-Xmx设为相同值，开发测试机JVM可以保留默认值 | -Xms1000M | 默认(MinHeapFreeRatio参数可以调整)空余堆内存小于40%时，JVM就会增大堆直到-Xmx的最大限制
-Xmx | 最大堆大小 | 物理内存的1/4(<1GB)，最佳设值应该视物理内存大小及计算机内其他内存开销而定 | -Xms1000M | 默认(MaxHeapFreeRatio参数可以调整)空余堆内存大于70%时，JVM会减少堆直到 -Xms的最小限制
-Xmn | 年轻代大小 | 不熟悉最好保留默认值 | 默认值 | 无
-XX:NewSize | 设置年轻代大小 | 无 | 不需要设置 | 无
-XX:MaxNewSize | 年轻代最大值 | 无 | 不需要设置 | 无
-Xss | 每个线程的堆栈大小 | JDK5.0 以后每个线程堆栈大小为1M,以前每个线程堆栈大小为256K. | 默认值 | 根据应用的线程所需内存大小进行调整。在相同物理内存下,减小这个值能生成更多的线程.但是操作系统对一个进程内的线程数还是有限制的,不能无限生成,经验值在3000~5000左右，一般小的应用， 如果栈不是很深， 应该是128k够用的 大的应用建议使用256k。这个选项对性能影响比较大，需要严格的测试。（校长）和threadstacksize选项解释很类似,官方文档似乎没有解释,在论坛中有这样一句话:””-Xss is translated in a VM flag named ThreadStackSize”一般设置这个值就可以了。
-XX:ThreadStackSize | 线程栈大小 | 上面的-Xss不需要设置，如果要设置直接设置这个参数就可以 | 默认值 | 无
-XX:NewRatio | 年轻代(包括Eden和两个Survivor区) | Xms=Xmx并且设置了Xmn的情况下，该参数不需要进行设置 | 默认值 | -XX:NewRatio=4表示年轻代与年老代所占比值为1:4,年轻代占整个堆栈的1/5。
-XX:SurvivorRatio | Eden区与Survivor区的大小比值 | 8:1:1 | 默认值 | 设置为8,则两个Survivor区与一个Eden区的比值为2:8,一个Survivor区占整个年轻代的1/10
-XX:LargePageSizeInBytes | 内存页的大小 | =128m，不可设置过大， 会影响Perm的大小 | 默认值 | 128m
-XX:+UseFastAccessorMethods | 原始类型的快速优化 | - | 默认值 | 无
-XX:+DisableExplicitGC | 关闭System.gc() | - | 默认值 | 这个参数需要严格的测试
-XX:MaxTenuringThreshold | 垃圾最大年龄，表示对象被移到老年代的年龄阈值的最大值 | 15 | 默认值 | 控制对象能经过几次GC才被转移到老年代。回收如果设置为0的话,则年轻代对象不经过Survivor区,直接进入年老代. 对于年老代比较多的应用,可以提高效率.如果将此值设置为一个较大值,则年轻代对象会在Survivor区进行多次复制,这样可以增加对象再年轻代的存活 时间,增加在年轻代即被回收的概率。该参数只有在串行GC时才有效。
-XX:+AggressiveOpts | 加快编译 | - | 默认值 | 启用该选项之后，需要考虑到性能的提升，同样也需要考虑到性能提升所带来的不稳定风险。
-XX:+UseBiasedLocking | 锁机制的性能改善 (Java 5 update 6 or later) | + | 默认值 | Java 5 HotSpot JDK需要明确的命令来启用这个特性，在使用-XX:+AggressiveOpts选项，有偏见的锁会Java 5中会被自动启用。在Java 6中是默认启用的。
-XX:+CollectGen0First | FullGC时是否先YGC | false | 默认值 | 无

#### 垃圾收集器相关参数
参数名称 | 含义 | 默认值 | 示例 | 说明
--- | --- | --- | --- | --- | ---
-XX:+UseParNewGC | 设置年轻代为并行收集 | - | + | 可与CMS收集同时使用，JDK5.0以上,JVM会根据系统配置自行设置,所以无需再设置此值
-XX:ParallelGCThreads | 并行收集器的线程数 | 默认为CPU核心数 | 默认值 | 此值最好配置与处理器数目相等 同样适用于CMS
-XX:+UseConcMarkSweepGC | 使用CMS内存收集 | - | + | 注意最新的JVM版本，当开启此选项时，-XX：UseParNewGC会自动开启。因此，如果年轻代的并行GC不想开启，可以通过设置-XX：-UseParNewGC来关掉。
-XX:ParallelCMSThreads | CMS并发收集线程数 | 默认为CPU核心数 | 默认值 | 如果还标志未设置，JVM会根据并行收集器中的-XX：ParallelGCThreads参数的值来计算出默认的并行CMS线程数。该公式是ConcGCThreads = (ParallelGCThreads + 3)/4。因此，对于CMS收集器， -XX:ParallelGCThreads标志不仅影响“stop-the-world”垃圾收集阶段，还影响并发阶段。总之，有不少方法可以配置CMS收集器的多线程执行。正是由于这个原因,建议第一次运行CMS收集器时使用其默认设置, 然后如果需要调优再进行测试
-XX:+UseCMSCompactAtFullCollection | 在FULL GC的时候， 对年老代 | - | + | CMS是不会移动内存的， 因此， 这个非常容易产生碎片， 导致内存不够用， 因此， 内存的压缩这个时候就会被启用。 增加这个参数是个好习惯。可能会影响性能,但是可以消除碎片
-XX:CMSFullGCsBeforeCompaction | full gc多少次后进行内存压缩 | 默认为0 | 默认值 | 由于并发收集器不对内存空间进行压缩,整理,所以运行一段时间以后会产生”碎片”,使得运行效率降低.此值设置运行多少次GC以后对内存空间进行压缩,整理.
-XX:CMSInitiatingOccupancyFraction | 老年代使用70％后开始CMS收集 | =92 | =75 | 为了保证不出现promotion failed(见下面介绍)错误,该值的设置需要满足以下公式
-XX:+UseCMSInitiatingOccupancyOnly | 只使用设定的回收阈值(- XX:CMSInitiatingOccupancyFraction设定的值)，如果不指定，JVM仅在第一次使用设定 值，后续则会自动调整 | | | 
-XX:+CMSClassUnloadingEnabled | 持久代使用CMS并发收集 | jdk1.7默认关闭,1.8默认打开 | - | 它会增加CMS remark的暂停时间，如果没有程序产生大量的临时类，新类加载并不频繁，这个参数还是不开的好
-XX:CMSInitiatingPermOccupancyFraction | 设置Perm Gen使用到达多少比率时触发 | =92 | 默认值 | 无

#### 日志相关参数
参数名称 | 含义 | 默认值 | 示例 | 说明
--- | --- | --- | --- | --- | ---
-Xloggc | 记录日志文件位置 | 无 | /data/log/jetty/gc.log | 无
-XX:+PrintGCDateStamps | 打印可读的日期而不是时间戳 | - | + | 无
-XX:+PrintGCDetails | 打印日志详情 | - | + | 输出形式:[GC [DefNew: 8614K->781K(9088K), 0.0123035 secs] 118250K->113543K(130112K), 0.0124633 secs][GC [DefNew: 8614K->8614K(9088K), 0.0000665 secs][Tenured: 112761K->10414K(121024K), 0.0433488 secs] 121376K->10414K(130112K), 0.0436268 secs]
-XX:+PrintGCApplicationStoppedTime | 打印GC停顿时间 | - | + | 它除了打印清晰的GC停顿时间外，还可以打印其他的停顿时间，比如取消偏向锁，class 被agent redefine，code deoptimization等等，有助于发现一些原来没想到的问题，建议也加上。输出形式:Total time for which application threads were stopped: 0.0468229 seconds
-XX:+PrintCommandLineFlags | 打印已配置的XX类参数 | - | + | 打印出命令行里设置了的参数以及因为这些参数隐式影响的参数，比如开了CMS后，-XX:+UseParNewGC也被自动打开
-XX:+HeapDumpOnOutOfMemoryError | 输出Heap Dump到指定文件 | - | + | 在Out Of Memory，JVM快死快死掉的时候，输出Heap Dump到指定文件。不然开发很多时候还真不知道怎么重现错误。路径只指向目录，JVM会保持文件名的唯一性，叫java_pid${pid}.hprof。如果指向文件，而文件已存在，反而不能写入。
-XX:HeapDumpPath | 设置Heap Dump输出路径 | 无 | =${LOGDIR}/ | 无
