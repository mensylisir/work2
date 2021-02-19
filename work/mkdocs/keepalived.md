## 监控脚本

```
vi /usr/monitor_docker_harbor.sh
#!/bin/bash
#监控容器的运行状态
containerName=harbor-core

# 查看进程是否存在
harborrun=`docker inspect --format '{{.State.Running}}' ${containerName}`
if [ "${harborrun}" != "true" ]; then
        cd /opt/harbor;docker-compose down;./prepare --with-notary --with-clair --with-chartmuseum;docker-compose up -d;
        sleep 180
        if [ "${harborrun}" != "true"  ]; then
                /bin/systemctl stop keepalived.service
        fi
fi
```

```
chmod +x /usr/monitor_docker_harbor.sh
```

安装keepalived

```
yum install keepalived
```

卸载keepalived

```
yum remove keepalived
```





keepalived主配置文件

```
vi /etc/keepalived/keepalived.conf
#VRRP 脚本声明
vrrp_script check_harbor {
	#周期性执行的脚本
    script "/usr/monitor_docker_harbor.sh"
    #运行脚本的间隔时间，秒 时间短会反复重启docker
    interval 200
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

keepalived备配置文件

```
vi /etc/keepalived/keepalived.conf
#VRRP 脚本声明
vrrp_script check_harbor {
	#周期性执行的脚本
    script "/usr/monitor_docker_harbor.sh"
    #运行脚本的间隔时间，秒
    interval 2
}

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

    real_server 192.168.81.102 80 {
        weight 1
    }
}
```

```
systemctl daemon-reload
systemctl start keepalived
systemctl status keepalived
systemctl enable keepalived
```

