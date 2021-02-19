1. download

   ```
   wget https://download.docker.com/linux/static/stable/x86_64/docker-19.03.9.tgz
   ```

   ```
   curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   ```

2. unpack

   ```
   tar -zxvf docker-19.03.9.tgz
   ```

3. move to /usr/local/bin

   ```
   cp docker/* /usr/local/bin
   ```

   ```
   cp docker-compose /usr/local/bin
   ```

4. create docker.service

   ```shell
   # vim /usr/lib/systemd/system/docker.service
   [Unit]
   Description=Docker Application Container Engine
   Documentation=https://docs.docker.com
   After=network-online.target firewalld.service
   Wants=network-online.target
   
   [Service]
   Type=notify
   ExecStart=/usr/local/bin/dockerd
   ExecReload=/bin/kill -s HUP $MAINPID
   LimitNOFILE=infinity
   LimitNPROC=infinity
   LimitCORE=infinity
   TimeoutStartSec=0
   Delegate=yes
   KillMode=process
   Restart=on-failure
   StartLimitBurst=3
   StartLimitInterval=60s
   
   [Install]
   WantedBy=multi-user.target
   ```




```
#cat /etc/docker/daemon.json 
{
  "registry-mirrors": [
    "https://qjzfwfvb.mirror.aliyuncs.com"
  ],
  "insecure-registries": [
    "harbor.rdev.tech",
    "192.168.80.59:80",
    "harbor.dev.rdev.tech",
    "192.168.80.22",
    "192.168.80.78",
    "192.168.80.77",
    "192.168.81.102",
    "harbor-dev2.rdev.tech",
    "192.168.80.54:8081"
  ],
  "default-address-pools":[
    {"base":"10.10.0.0/16","size":24}
  ],
  "debug": true,
  "experimental": false
}
```



```
systemctl daemon-reload
systemctl enable docker
systemctl start docker
systemctl status docker
```







### 离线安装网信系统

```
#安装docker和docker-compose后
./install.sh
ncims@123.!
create database nc_ims;
show databases;
use nc_ims;
source nc_ims.sql;
```





```
docker save java:8 -o java.tar  #将java 8的镜像导出成tar文件
docker load -i java.tar
```



```
#前端启动
docker run -d -p 3605:3605 --name ncims-portal harbor.dev.rdev.tech/ncims/ncims-portal:c2fe12c
#访问地址
http://172.25.45.165:3605/
```



```
#后端启动
docker run -d -p 18080:8080 -v D:\tools\docker\conf:/conf --restart=always --name ncims-backend c2a622b97fe0
```



```
修改前端代理
docker cp .\default.conf ncims-portal:/etc/nginx/conf.d/
```



```
#启动数据库
192.168.80.54:8081/library/mysql:latest

docker run -d -p 31306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=root  192.168.80.54:8081/library/mysql:latest

docker exec -it mysql bash
mysql -u root -p 
root 
create database nc_ims #创建nc_ims

docker cp nc_ims.sql mysql:/
docker exec -it mysql bash
mysql -u root -proot
show databases;
use nc_ims;
source /nc_ims.sql;


```

