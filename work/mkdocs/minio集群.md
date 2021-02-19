





```
docker run -d --net=host --restart always --name=minio -p 9000:9000 -e MINIO_ACCESS_KEY=minio -e MINIO_SECRET_KEY=minio123  -v /data/minio:/data/minio 192.168.80.54:8081/library/minio/minio:latest server http://192.168.80.86:9000/data/minio/disk1  http://192.168.80.86:9000/data/minio/disk2 http://192.168.80.86:9000/data/minio/disk3 http://192.168.80.86:9000/data/minio/disk4 http://192.168.80.87:9000/data/minio/disk1  http://192.168.80.87:9000/data/minio/disk2 http://192.168.80.87:9000/data/minio/disk3  http://192.168.80.87:9000/data/minio/disk4 http://192.168.80.88:9000/data/minio/disk1  http://192.168.80.88:9000/data/minio/disk2 http://192.168.80.88:9000/data/minio/disk3 http://192.168.80.88:9000/data/minio/disk4 

docker run -d --net=host --restart always --name=minio -p 9000:9000 -e MINIO_ACCESS_KEY=minio -e MINIO_SECRET_KEY=minio123  -v /opt/data/minio:/opt/data/minio 192.168.80.54:8081/library/minio/minio:latest server http://192.168.80.62:9000/opt/data/minio/disk1  http://192.168.80.62:9000/opt/data/minio/disk2 http://192.168.80.62:9000/opt/data/minio/disk3 http://192.168.80.62:9000/opt/data/minio/disk4 http://192.168.80.63:9000/opt/data/minio/disk1  http://192.168.80.63:9000/opt/data/minio/disk2 http://192.168.80.63:9000/opt/data/minio/disk3 http://192.168.80.63:9000/opt/data/minio/disk4 http://192.168.80.64:9000/opt/data/minio/disk1  http://192.168.80.64:9000/opt/data/minio/disk2 http://192.168.80.64:9000/opt/data/minio/disk3 http://192.168.80.64:9000/opt/data/minio/disk4


docker run -d --net=host --restart always --name=minio -p 9000:9000 -e MINIO_ACCESS_KEY=minio -e MINIO_SECRET_KEY=minio123  -v /opt/data/minio:/data/minio 192.168.80.54:8081/library/minio/minio:latest server http://192.168.80.62:9000/opt/data/minio/disk1  http://192.168.80.62:9000/opt/data/minio/disk2 http://192.168.80.62:9000/opt/data/minio/disk3 http://192.168.80.62:9000/opt/data/minio/disk4 http://192.168.80.63:9000/opt/data/minio/disk1  http://192.168.80.63:9000/opt/data/minio/disk2 http://192.168.80.63:9000/opt/data/minio/disk3 http://192.168.80.63:9000/opt/data/minio/disk4 http://192.168.80.64:9000/opt/data/minio/disk1  http://192.168.80.64:9000/opt/data/minio/disk2 http://192.168.80.64:9000/opt/data/minio/disk3 http://192.168.80.64:9000/opt/data/minio/disk4

```

1、环境信息

| ip            | hostname |
| ------------- | -------- |
| 192.168.80.86 | minio2   |
| 192.168.80.87 | minio3   |
| 192.168.80.88 | minio4   |

2、配置主机名（所有节点）

```
vi /etc/hosts

192.168.80.86 minio2 192.168.80.87 minio3 192.168.80.88 minio4             
```

3、关闭selinux（所有节点）

  ```
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config setenforce 0 
  ```

4、关闭防火墙（所有节点）

 ```
#查看防火墙状态 
systemctl status firewalld  
#临时关闭防火墙命令。重启电脑后，防火墙自动起来。 
systemctl stop firewalld  
#永久关闭防火墙命令。重启后，防火墙不会自动启动。 
systemctl disable firewalld     
 ```

5、修改/etc/sysctl.conf （所有节点）

 ```
net.ipv4.ip_forward=1 
# net.ipv4.ip_local_reserved_ports=30000-32767 
net.bridge.bridge-nf-call-iptables=1 
net.bridge.bridge-nf-call-arptables=1 
net.bridge.bridge-nf-call-ip6tables=1         
 ```

6、生效（所有节点）

```
sysctl -p         
```

7、配置本地源（所有节点）

​                拷贝本地源              

8、安装docker（所有节点）

​                yum -y install docker-ce              

9、配置（所有节点）

vi /etc/docker/daemon.json

​                cd /etc/docker  vi /etc/docker/daemon.json 写入内容 {  "insecure-registries" : ["192.168.106.140:8081"]#harbor地址 } 重启docker  systemctl daemon-reload systemctl stop docker.service systemctl start docker.service  systemctl enable docker.service 查看所有服务是否启动完成              

10、安装minio集群（所有节点）

文档中每台服务器上挂载/data/minio/disk1、/data/minio/disk2、/data/minio/disk3、/data/minio/disk4 

10.1、创建目录（所有节点）

​                 mkdir /data/minio/disk1 /data/minio/disk2 /data/minio/disk3 /data/minio/disk4              

10.2、创建集群（所有节点）

  ```
docker run -d --net=host --restart always --name=minio -p 9000:9000 -e MINIO_ACCESS_KEY=minio -e MINIO_SECRET_KEY=minio123  -v /data/minio:/data/minio 192.168.80.54:8081/library/minio/minio:latest server http://192.168.80.86:9000/data/minio/disk1  http://192.168.80.86:9000/data/minio/disk2 http://192.168.80.86:9000/data/minio/disk3 http://192.168.80.86:9000/data/minio/disk4 http://192.168.80.87:9000/data/minio/disk1  http://192.168.80.87:9000/data/minio/disk2 http://192.168.80.87:9000/data/minio/disk3  http://192.168.80.87:9000/data/minio/disk4 http://192.168.80.88:9000/data/minio/disk1  http://192.168.80.88:9000/data/minio/disk2 http://192.168.80.88:9000/data/minio/disk3 http://192.168.80.88:9000/data/minio/disk4               
  ```

11、验证

​                地址： 集群ip:9000   例如192.168.106.192:9000 账号密码（创建集群中设置，如下2个参数） MINIO_ACCESS_KEY=minio -e MINIO_SECRET_KEY=minio123