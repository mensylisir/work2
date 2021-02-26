```
docker run --name=postgresql-redmine -d \
  --env='DB_NAME=redmine_production' \
  --env='DB_USER=redmine' --env='DB_PASS=password' \
  --volume=/opt/redmine/postgresql:/var/lib/postgresql \
  harbor.rdev.tech/sameersbn/postgresql:9.6-4
```

```
docker run --name=redmine -d \
  --link=postgresql-redmine:postgresql --publish=10083:80 \
  --env='REDMINE_PORT=10083' \
  --volume=/opt/redmine/redmine:/home/redmine/data \
  --volume=/opt/redmine/redmine-logs:/var/log/redmine/ \
  harbor.rdev.tech/sameersbn/redmine:4.1.1-5
```



###  迁移并且切换nfs



```
# 去nfs服务器创建目录并添加777权限
cd /opt/nfsmount;mkdir redmine-1921688073-21210126;chmod +777 redmine-1921688073-21210126;#在nfs服务器192.168.81.105操作
# 安装nfs 客户端 (客户端执行)
yum install nfs-utils # 所有的k8s worker节点都需要安装
mkdir -p /opt/redmine;mount -t nfs 192.168.81.105:/data/nfsmount/redmine-1921688073-21210126 /opt/redmine
# 拷贝备份
scp -r root@192.168.71.68:/opt/redmine/* /opt/redmine/
#按照上边命令启动镜像并登录
```



#  添加域名和https



```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: redmine
  namespace: dev
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: 50m
spec:
  rules:
  - host: redmine-dev.rdev.tech
    http:
      paths:
      - backend:
          serviceName: redmine
          servicePort: 80
  tls:
  - hosts:
    - redmine-dev.rdev.tech
    secretName: redmine-dev-tls-pem
---
apiVersion: v1
kind: Endpoints
metadata:
  name: redmine
  namespace: dev
subsets:
  - addresses:
      - ip: 192.168.80.73
    ports:
      - port: 10083

---
apiVersion: v1
kind: Service
metadata:
  name: redmine
  namespace: dev
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 10083
```



```
#生成cert
kubectl create secret tls redmine-dev-tls-pem -n dev --cert=redmine-dev.pem --key=redmine-dev-key.pem --dry-run -o yaml > redmine-tls.yaml
kubectl apply -f redmine-tls.yaml
```



### 解决上传50m限制

```
#需要修改3个位置
#1 web页面设置 管理-配置-文件-附件大小限制51200KB
#2 修改docker内的nginx中大小 /etc/nginx/sites-enabled/redmine 
client_max_body_size 20m; 修改成50m
#3 修改ingress的添加限制
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: 50m

```





