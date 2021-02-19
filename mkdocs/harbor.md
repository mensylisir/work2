> 1. Download
>
>    ```
>    https://github.com/goharbor/harbor/releases/download/v1.10.6/harbor-offline-installer-v1.10.6.tgz
>    ```

> 2. unpack
>
>    ```
>    tar -zxvf harbor-offline-installer-v1.1.1.tgz
>    ```

> 3. enter directory
>
>    ```
>    cd harbor
>    ```

> 4. edit config
>
>    ```
>    vim harbor.cfg
>    
>    修改一下内容
>    hostname = 192.168.80.77 #修改harbor的启动ip，这里需要依据系统ip设置
>    harbor_admin_password = Def@u1tpwd #修改harbor的admin用户的密码
>    ```

> 5. install
>
>    ```
>    /prepare
>    ```
>
>    ```
>    ./install.sh
>    ```



## Habor ssl配置

### Generate a Certificate Authority Certificate

1. Generate a CA certificate private key.

   ```
   openssl genrsa -out ca.key 4096
   ```

2. Generate the CA certificate

   ```
   openssl req -x509 -new -nodes -sha512 -days 3650 \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=harbor-dev2.rdev.tech" \
    -key ca.key \
    -out ca.crt
   ```

### Generate a Server Certificate

1. Generate a private key.

   ```
   openssl genrsa -out harbor-dev2.rdev.tech.key 4096
   ```

2. Generate a certificate signing request (CSR).

   ```
   openssl req -sha512 -new \
       -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=harbor-dev2.rdev.tech" \
       -key harbor-dev2.rdev.tech.key \
       -out harbor-dev2.rdev.tech.csr
   ```

3. Generate an x509 v3 extension file.

   ```
   cat > v3.ext <<-EOF
   authorityKeyIdentifier=keyid,issuer
   basicConstraints=CA:FALSE
   keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
   extendedKeyUsage = serverAuth
   subjectAltName = @alt_names
   
   [alt_names]
   DNS.1=harbor-dev2.rdev.tech
   DNS.2=harbor-dev2
   DNS.3=harbor2
   EOF
   ```

4. Use the `v3.ext` file to generate a certificate for your Harbor host.

   ```
   openssl x509 -req -sha512 -days 3650 \
       -extfile v3.ext \
       -CA ca.crt -CAkey ca.key -CAcreateserial \
       -in harbor-dev2.rdev.tech.csr \
       -out harbor-dev2.rdev.tech.crt
   ```

### Provide the Certificates to Harbor and Docker

1. Copy the server certificate and key into the certficates folder on your Harbor host.

   ```
   cp harbor-dev2.rdev.tech.crt /data/cert/
   cp harbor-dev2.rdev.tech.key /data/cert/
   ```

2. Convert `yourdomain.com.crt` to `yourdomain.com.cert`, for use by Docker.

   ```
   openssl x509 -inform PEM -in harbor-dev2.rdev.tech.crt -out harbor-dev2.rdev.tech.cert
   ```

3. Copy the server certificate, key and CA files into the Docker certificates folder on the Harbor host. You must create the appropriate folders first.

   ```
   cp harbor-dev2.rdev.tech.cert /etc/docker/certs.d/harbor-dev2.rdev.tech/
   cp harbor-dev2.rdev.tech.key /etc/docker/certs.d/harbor-dev2.rdev.tech/
   cp ca.crt /etc/docker/certs.d/harbor-dev2.rdev.tech/
   ```

4. Restart Docker Engine.

   ```
   systemctl restart docker
   ```

### Deploy or Reconfigure Harbor

1. Run the `prepare` script to enable HTTPS.

   ```
   ./prepare
   ```

2. If Harbor is running, stop and remove the existing instance.

   ```
   docker-compose down -v
   ```

3. Restart Harbor

   ```
   docker-compose up -d
   ```

### Verify the HTTPS Connection

- Open a browser and enter [https://yourdomain.com](https://links.jianshu.com/go?to=https%3A%2F%2Fyourdomain.com%2F). It should display the Harbor interface.

  Some browsers might show a warning stating that the Certificate Authority (CA) is unknown. This happens when using a self-signed CA that is not from a trusted third-party CA. You can import the CA to the browser to remove the warning.

- On a machine that runs the Docker daemon, check the `/etc/docker/daemon.json` file to make sure that the `-insecure-registry` option is not set for [https://yourdomain.com](https://links.jianshu.com/go?to=https%3A%2F%2Fyourdomain.com%2F).

- Log into Harbor from the Docker client.

  ```
  docker login yourdomain.com
  ```

- If you've mapped `nginx` 443 port to a different port,add the port in the `login` command.

  ```
  docker login yourdomain.com:port
  ```

  

## Harbor HA

### 主备机器安装keepalived

```
yum install keepalived -y
```

### 确定master和backup机器的网卡

```
ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:50:56:b9:29:d0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.81.102/22 brd 192.168.83.255 scope global noprefixroute ens160
       valid_lft forever preferred_lft forever
```

### 配置keepalived

#### master

```
# vim /etc/keepalived/keepalived.conf
```

```
vrrp_instance VI_1 {
    # 指定 keepalived 的角色，MASTER 表示此主机是主服务器，BACKUP 表示此主机是备用服务器
    state MASTER

    # 指定网卡
    interface ens160

    # 虚拟路由标识，这个标识是一个数字，同一个vrrp实例使用唯一的标识。
    # 即同一vrrp_instance下，MASTER和BACKUP必须是一致的
    virtual_router_id 51

    # 定义优先级，数字越大，优先级越高（0-255）。
    # 在同一个vrrp_instance下，MASTER 的优先级必须大于 BACKUP 的优先级
    priority 100

    # 设定 MASTER 与 BACKUP 负载均衡器之间同步检查的时间间隔，单位是秒
    advert_int 1

  
    # 设置验证类型和密码
    authentication {
        #设置验证类型，主要有PASS和AH两种
        auth_type PASS
        #设置验证密码，在同一个vrrp_instance下，MASTER与BACKUP必须使用相同的密码才能正常通信
        auth_pass 1111
    }

    #设置虚拟IP地址，可以设置多个虚拟IP地址，每行一个
    virtual_ipaddress {
        # 虚拟 IP
        192.168.80.22    
     }
}

# 虚拟服务器端口配置
virtual_server 192.168.80.22 80 {
    delay_loop 6
    lb_algo rr
    lb_kind NAT
    persistence_timeout 50
    protocol TCP

    real_server 192.168.80.78 80 {
        weight 1
    }
}
```

#### backup

```
# vim /etc/keepalived/keepalived.conf
```

```
vrrp_instance VI_1 {
    # 指定 keepalived 的角色，MASTER 表示此主机是主服务器，BACKUP 表示此主机是备用服务器
    state BACKUP

    # 指定网卡
    interface ens160

    # 虚拟路由标识，这个标识是一个数字，同一个vrrp实例使用唯一的标识。
    # 即同一vrrp_instance下，MASTER和BACKUP必须是一致的
    virtual_router_id 51

    # 定义优先级，数字越大，优先级越高（0-255）。
    # 在同一个vrrp_instance下，MASTER 的优先级必须大于 BACKUP 的优先级
    priority 90

    # 设定 MASTER 与 BACKUP 负载均衡器之间同步检查的时间间隔，单位是秒
    advert_int 1

  
    # 设置验证类型和密码
    authentication {
        #设置验证类型，主要有PASS和AH两种
        auth_type PASS
        #设置验证密码，在同一个vrrp_instance下，MASTER与BACKUP必须使用相同的密码才能正常通信
        auth_pass 1111
    }

    #设置虚拟IP地址，可以设置多个虚拟IP地址，每行一个
    virtual_ipaddress {
        # 虚拟 IP
        192.168.80.22    
     }
}

# 虚拟服务器端口配置
virtual_server 192.168.80.22 80 {
    delay_loop 6
    lb_algo rr
    lb_kind NAT
    persistence_timeout 50
    protocol TCP

    real_server 192.168.81.102 80 {
        weight 1
    }
}
```

### 启用keepalived

```
systemctl start keepalived
```

```
systemctl enable keepalived
```

```
#VRRP 脚本声明
vrrp_script check_harbor {
        #周期性执行的脚本
    script "/usr/monitor_docker_harbor.sh"
    #运行脚本的间隔时间，秒
    interval 2
}

vrrp_instance VI_1 {
    # 指定 keepalived 的角色，MASTER 表示此主机是主服务器，BACKUP 表示此主机是备用服务器
    state MASTER

    # 指定网卡
    interface ens160

    # 虚拟路由标识，这个标识是一个数字，同一个vrrp实例使用唯一的标识。
    # 即同一vrrp_instance下，MASTER和BACKUP必须是一致的
    virtual_router_id 51

    # 定义优先级，数字越大，优先级越高（0-255）。
    # 在同一个vrrp_instance下，MASTER 的优先级必须大于 BACKUP 的优先级
    priority 100

    # 设定 MASTER 与 BACKUP 负载均衡器之间同步检查的时间间隔，单位是秒
    advert_int 1


    # 设置验证类型和密码
    authentication {
        #设置验证类型，主要有PASS和AH两种
        auth_type PASS
        #设置验证密码，在同一个vrrp_instance下，MASTER与BACKUP必须使用相同的密码才能正常通信
        auth_pass 1111
    }

    #设置虚拟IP地址，可以设置多个虚拟IP地址，每行一个
    virtual_ipaddress {
        # 虚拟 IP
        192.168.80.22
     }
    #脚本监控状态
    track_script {
        check_harbor
    }    
}

# 虚拟服务器端口配置
virtual_server 192.168.80.22 80 {
    delay_loop 6
    lb_algo rr
    lb_kind NAT
    persistence_timeout 50
    protocol TCP

    real_server 192.168.80.78 80 {
        weight 1
    }
}

```

```
#!/bin/bash
#监控容器的运行状态
containerName=harbor-core

# 查看进程是否存在
harborrun=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${harborrun}" != "true" ]; then
        cd /opt/harbor;docker-compose down;./prepare --with-notary --with-clair --with-chartmuseum;docker-compose up -d;sleep 180
        if [ "${harborrun}" != "true"  ]; then
               echo stop keepalived;/bin/systemctl stop keepalived.service
        fi
fi
```

### 解决harbor启动创建网桥和子网冲突

```
vi  /etc/docker/daemon.json 

{
  "registry-mirrors": [
    "https://qjzfwfvb.mirror.aliyuncs.com"
  ],
  "insecure-registries": [
    "harbor.rdev.tech",
    "192.168.80.59:80",
    "harbor-dev.rdev.tech",
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
[root@demo-master-1 harbor]# route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         gateway         0.0.0.0         UG    100    0        0 ens160
10.10.0.0       0.0.0.0         255.255.255.0   U     0      0        0 docker0
10.10.1.0       0.0.0.0         255.255.255.0   U     0      0        0 br-a7caae876951
10.10.2.0       0.0.0.0         255.255.255.0   U     0      0        0 br-923280178e3a
10.10.3.0       0.0.0.0         255.255.255.0   U     0      0        0 br-49968ab618a2
10.10.4.0       0.0.0.0         255.255.255.0   U     0      0        0 br-de2fc35d3f14
10.10.5.0       0.0.0.0         255.255.255.0   U     0      0        0 br-29697cb95a01
192.168.80.0    0.0.0.0         255.255.252.0   U     100    0        0 ens160
```

### 解决集群下载https失败

```
mkdir -p /etc/docker/certs.d/harbor-dev.rdev.tech

openssl x509 -outform der -in ca.pem -out ca.crt

openssl x509 -inform PEM -in harbor-dev.pem -out harbor-dev.cert  
openssl x509 -inform PEM -in /opt/bak/ca.pem -out rdev.tech.cert 

openssl x509 -inform PEM -in /opt/bak/harbor-dev.pem -out harbor-dev.rdev.tech.cert 
```



### harbor存储切换NFS



```
#nfs服务器执行，去nfs服务器创建目录并添加777权限
cd /opt/mountnfs;mkdir harbor-1921688078-20210126;chmod +777 harbor-1921688078-20210126;#在nfs服务器192.168.81.106操作
#harbor机器执行，安装nfs 客户端 (客户端执行)harbor-1921688078-20210126
yum install nfs-utils # 所有的k8s worker节点都需要安装
mkdir -p /opt/data;mount -t nfs 192.168.81.106:/data/nfsmount/harbor-1921688078-20210126 /opt/data
#修改harbor.yal,修改挂载地址
#把之前的/data目录下文件拷贝到挂载目录，并添加权限。
cp -rf /data/* /opt/data/
chmod +777 -R /opt/data
#重新停掉harbor并重新安装
cd /opt/harbor
docker-compose down
./install.sh --with-notary --with-clair --with-trivy --with-chartmuseum
#查看系统是否启动，并切是否可以和其他harbor复制镜像
```

