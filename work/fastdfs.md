##### fastdfs自动部署shell
```sh
#!/bin/bash
cd /home/ubuntu/code/pangolin/fastdfs
git pull
if [ $? -ne 0 ]
  then
    echo "拉取代码失败"
    exit 1
  else
    sudo docker stop pangolin-fastdfs #停止容器
    if [ $? -ne 0 ]
      then
        exit 2
    fi
    echo "停止容器成功..."
    sudo docker rm pangolin-fastdfs #删除容器
    if [ $? -ne 0 ]
      then
        exit 3
    fi
    echo “删除容器成功...”
    sudo docker rmi $(sudo docker images | grep sh/fastdfs | awk '{print $3}') #删除镜像
    if [ $? -ne 0 ]
      then
        exit 4
    fi
    echo "删除镜像成功..."
    #制作镜像
    sudo docker build --no-cache -t sh/fastdfs:0.0.1 --build-arg JAR_FILE=target/fastdfs-1.0-SNAPSHOT.jar .
    if [ $? -ne 0 ]
      then
        exit 5
    fi
    #创建容器并启动
    cd /home/ubuntu/docker/fastdfs
    sudo docker-compose up -d
    if [ $? -eq 0 ]
      then
        echo "================================================================="
        echo "success"
    fi
    sudo docker rmi -f $(sudo docker images -f "dangling=true" -q)
fi
```
