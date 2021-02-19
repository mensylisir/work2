### 安装nginx



```
#编译环境
yum install -y vim-enhanced
yum install -y gcc gcc-c++
yum install -y pcre pcre-devel
yum install -y zlib zlib-devel
yum install -y openssl openssl-devel
#下载nginx
cd /opt/nginx
wget http://nginx.org/download/nginx-1.9.12.tar.gz  
tar -zxvf nginx-1.9.12.tar.gz  
cd nginx-1.19.12
#下载正向代理模块
https://github.com/chobits/ngx_http_proxy_connect_module
#传到机器上后解压到/opt/nginx/patch/目录并加载
patch -p1 < /opt/nginx/patch/ngx_http_proxy_connect_module-master/patch/proxy_connect.patch
#添加编译时模块
./configure --add-dynamic-module=/opt/nginx/patch/ngx_http_proxy_connect_module-master
make && make install
#查看配置是否正确
/usr/local/nginx/sbin/nginx -t
/usr/local/nginx/sbin/nginx
#关闭防火墙并测试
systemctl stop firewalld 
#测试nginx  浏览器打开地址查看
192.168.80.11
```



#### 修改nginx.conf

```
#在添加正向代理模块
load_module /usr/local/nginx/modules/ngx_http_proxy_connect_module.so;
#在http的{}内添加正向代理
 server {
     listen                         8443;

     # dns resolver used by forward proxying
     resolver                       114.114.114.114;

     # forward proxy for CONNECT request
     proxy_connect;
     proxy_connect_allow            443 80 ;
     proxy_connect_connect_timeout  10s;
     proxy_connect_read_timeout     10s;
     proxy_connect_send_timeout     10s;

     # forward proxy for non-CONNECT request
     location / {
         proxy_pass http://$host;
         proxy_set_header Host $host;
     }
 }
```

##### 测试代理

```
curl https://github.com/ -v -x 192.168.80.11:8443
#或者配置变量测试
export https_proxy=192.168.80.11:8443 #https代理
export http_proxy=192.168.80.11:8443  #http代理
curl https://www.baidu.com
#nexus代理
nexus在客户端的 设置-system-HTTP-HTTP proxy和HTTPS proxy中添加代理
# wget使用代理下载
wget https://download.docker.com/linux/static/stable/x86_64/docker-19.03.9.tgz  -e https_proxy=192.168.80.11:8443

```

![image-20210120091039133](nginx%E5%8F%8D%E5%90%91%E4%BB%A3%E7%90%86.assets/image-20210120091039133.png)



### 配置nginx 开机启动



```
# 创建nginx.service
vim /usr/lib/systemd/system/nginx.service
[Unit]
Description=nginx - high performance web server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t -c /usr/local/nginx/conf/nginx.conf   
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf         
ExecReload=/usr/local/nginx/sbin/nginx -s reload                                 
ExecStop=/usr/local/nginx/sbin/nginx -s stop                                     
ExecQuit=/usr/local/nginx/sbin/nginx -s quit                                     
PrivateTmp=true
[Install]
WantedBy=multi-user.target
```



#### 启动服务

```
chmod +x nginx.service 
systemctl daemon-reload
systemctl start nginx.service
# 有占用端口报错。  nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
#安装lsof 
yum install lsof
#查询占用80的端口
lsof -i:80
COMMAND   PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
nginx   11045   root    6u  IPv4 214271      0t0  TCP *:http (LISTEN)
nginx   11046 nobody    6u  IPv4 214271      0t0  TCP *:http (LISTEN)
#kill掉进程
kill -9 11045
kill -9 11046
#再次启动ok
systemctl start nginx.service 
systemctl enable nginx
```



###  解决传输文件太大

```
client_max_body_size     50m; //文件大小限制，默认1m
client_header_timeout    1m;
client_body_timeout      1m;
proxy_connect_timeout     60s;
proxy_read_timeout      1m;
proxy_send_timeout      1m;
```



### docker添加代理(待验证)

```
mkdir -p /etc/systemd/system/docker.service.d
cat /etc/systemd/system/docker.service.d/http-proxy.conf

[Service]
 # NO_PROXY is optional and can be removed if not needed
 # Change proxy_url to your proxy IP or FQDN and proxy_port to your proxy port
 # For Proxy server which require username and password authentication, just add the proper username and password to the URL. (see example below)

 # Example without authentication
 # Environment="HTTP_PROXY=http://proxy_url:proxy_port" "NO_PROXY=localhost,127.0.0.0/8"
 Environment="HTTP_PROXY=192.168.80.11:8443" "HTTPS_PROXY=192.168.80.11:8443" "NO_PROXY=localhost,127.0.0.0/8"

 # Example with authentication
 # Environment="HTTP_PROXY=http://username:password@proxy_url:proxy_port" "NO_PROXY=localhost,127.0.0.0/8"
```

