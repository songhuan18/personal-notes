##### gather自动部署shell
```sh
#!/bin/bash
cd /home/ubuntu/code/pangolin/
file=$(ls -l | grep gather | awk '{print $9}')
if [ -z "$file" ]
  then
    git clone git@192.168.10.200:pangolin/gather.git
    if [ $? -ne 0 ]
      then
        exit 1
    fi
    cd gather
    sudo docker build --no-cache -t sh/gather:0.0.1 --build-arg JAR_FILE=target/gather-0.0.1-SNAPSHOT.jar .
    cd /home/ubuntu/docker/gather
    sudo docker-compose up -d
    if [ $? -ne 0 ]
      then
        exit 6
    fi
    echo "============================SUCCESS=================================================="
    sudo docker rmi -f $(sudo docker images -f "dangling=true" -q)
  else
    container_stop=$(sudo docker ps | grep pangolin-gather | awk '{ print $1 }')
    if [ -n "$container_stop" ]
      then
        sudo docker stop $container_stop #停止容器
        if [ $? -ne 0 ]
          then
            exit 2
        fi
       echo "stop pangolin-gather container success..."
    fi
    container_del=$(sudo docker ps -a | grep pangolin-gather | awk '{ print $1 }')
    if [ -n "$container_del" ]
      then
        sudo docker rm $container_del #删除容器
        if [ $? -ne 0 ]
          then
            exit 3
        fi
        echo "delete pangolin-gather container success.."
    fi
    image_del=$(sudo docker images | grep sh/gather | awk '{ print $3 }')
    if [ -n "$image_del" ]
      then
        sudo docker rmi $image_del
        if [ $? -ne 0 ]
          then
            exit 4
        fi
        echo "delete image success..."
    fi
    cd gather
    git pull
    if [ $? -ne 0 ]
      then
        exit 5
    fi
    #制作镜像
    sudo docker build --no-cache -t sh/gather:0.0.1 --build-arg JAR_FILE=target/gather-0.0.1-SNAPSHOT.jar .
    if [ $? -ne 0 ]
      then
        exit 7
    fi
    #创建容器并启动容器
    cd /home/ubuntu/docker/gather
    sudo docker-compose up -d
    if [ $? -eq 0 ]
      then
        echo "============================SUCCESS=================================================="
    fi
    sudo docker rmi -f $(sudo docker images -f "dangling=true" -q)
fi
```
