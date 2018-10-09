##### gather自动部署shell
```sh
#!/bin/bash
PROJECT=gather
cd /home/ubuntu/code/pangolin/
file=$(ls -l | grep $PROJECT | awk '{print $9}')
if [ -z "$file" ]
  then
    git clone git@192.168.10.200:pangolin/$PROJECT.git
    if [ $? -ne 0 ]
      then
        exit 1
    fi
    cd $PROJECT
    sudo docker build --no-cache -t sh/$PROJECT:0.0.1 --build-arg JAR_FILE=target/$PROJECT-0.0.1-SNAPSHOT.jar .
    cd /home/ubuntu/docker/$PROJECT
    sudo docker-compose up -d
    if [ $? -ne 0 ]
      then
        exit 6
    fi
    echo "============================SUCCESS=================================================="
    sudo docker rmi -f $(sudo docker images -f "dangling=true" -q)
  else
    container_stop=$(sudo docker ps | grep pangolin-$PROJECT | awk '{ print $1 }')
    if [ -n "$container_stop" ]
      then
        sudo docker stop $container_stop #停止容器
        if [ $? -ne 0 ]
          then
            exit 2
        fi
       echo "stop pangolin-$PROJECT container success..."
    fi
    container_del=$(sudo docker ps -a | grep pangolin-$PROJECT | awk '{ print $1 }')
    if [ -n "$container_del" ]
      then
        sudo docker rm $container_del #删除容器
        if [ $? -ne 0 ]
          then
            exit 3
        fi
        echo "delete pangolin-$PROJECT container success.."
    fi
    image_del=$(sudo docker images | grep sh/$PROJECT | awk '{ print $3 }')
    if [ -n "$image_del" ]
      then
        sudo docker rmi $image_del
        if [ $? -ne 0 ]
          then
            exit 4
        fi
        echo "delete image success..."
    fi
    cd $PROJECT
    git pull
    if [ $? -ne 0 ]
      then
        exit 5
    fi
    #制作镜像
    sudo docker build --no-cache -t sh/$PROJECT:0.0.1 --build-arg JAR_FILE=target/$PROJECT-0.0.1-SNAPSHOT.jar .
    if [ $? -ne 0 ]
      then
        exit 7
    fi
    #创建容器并启动容器
    cd /home/ubuntu/docker/$PROJECT
    sudo docker-compose up -d
    if [ $? -eq 0 ]
      then
        echo "============================SUCCESS=================================================="
    fi
    sudo docker rmi -f $(sudo docker images -f "dangling=true" -q)
fi
```
