##### taglibrary自动化部署shell
```sh
#!/bin/bash
cd /home/ubuntu/code/pangolin
file=$(ls -l | grep taglibrary | awk '{print $9}')
if [ -z $file ]
  then
    git clone git@192.168.10.200:pangolin/taglibrary.git
    if [ $? -ne 0 ]
      then
        exit 1
    fi
    cd taglibrary
    sudo docker build --no-cache -t sh/taglibrary:0.0.1 --build-arg JAR_FILE=target/taglibrary-0.0.1-SNAPSHOT.jar .
    sudo docker rmi -f $(sudo docker images -f "dangling=true" -q)
    cd /home/ubuntu/docker/taglibrary
    sudo docker-compose up -d
    if [ $? -ne 0 ]
      then
        exit 6
    fi
    echo "================================================================="
    echo "success"
  else
    stop=$(sudo docker stop pangolin-taglibrary) #停止容器
    if [ $? -ne 0 ]
      then
        echo "停止容器失败..."
    fi
    echo "$stop"
    del=$(sudo docker rm pangolin-taglibrary) #删除容器
    if [ $? -ne 0 ]
      then
       echo "删除容器失败..."
    fi
    echo "$del"
    container_id=$(sudo docker images | grep sh/taglibrary | awk '{print $3}')
    if [ -n "$container_id" ]
      then
        sudo docker rmi $container_id
      	if [ $? -ne 0 ]
      	  then
                  echo "删除镜像失败，请手动删除"
                  exit 4
	fi
	echo "镜像删除成功"
    fi
    cd taglibrary
    git pull
    if [ $? -ne 0 ]
      then
        echo "拉取代码失败..."
        exit 3
    fi
    #制作镜像
    sudo docker build --no-cache -t sh/taglibrary:0.0.1 --build-arg JAR_FILE=target/taglibrary-0.0.1-SNAPSHOT.jar .
    if [ $? -ne 0 ]
      then
        exit 5
    fi
    #创建容器并启动
    cd /home/ubuntu/docker/taglibrary
    sudo docker-compose up -d
    if [ $? -eq 0 ]
      then
        echo "================================================================="
        echo "success"
    fi
    sudo docker rmi -f $(sudo docker images -f "dangling=true" -q)
fi
```
