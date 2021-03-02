```
docker run --name=wiki_db_1
```

```
docker run --name=wiki_wiki_1 
```



###  迁移并且切换nfs



```
# 去nfs服务器创建目录并添加777权限
cd /data/nfsmount;mkdir wiki-1921688073-21210127;chmod +777 wiki-1921688073-21210127;#在nfs服务器192.168.81.105操作
# 安装nfs 客户端 (客户端执行)
yum install nfs-utils # 所有的k8s worker节点都需要安装
mkdir -p /opt/wiki;mount -t nfs 192.168.81.105:/data/nfsmount/wiki-1921688073-21210127 /opt/wiki
#在原来节点上停掉docker
docker stop wiki_wiki_1
docker stop wiki_db_1
# 拷贝备份
scp -r root@192.168.80.89:/opt/wiki/* /opt/wiki/
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
  - host: redmine.dev.rdev.tech
    http:
      paths:
      - backend:
          serviceName: redmine
          servicePort: 80
  tls:
  - hosts:
    - redmine.dev.rdev.tech
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
kubectl create secret tls wiki-dev-tls-pem -n dev --cert=wiki-dev.pem --key=wiki-dev-key.pem --dry-run -o yaml > wiki-tls.yaml
kubectl apply -f wiki-tls.yaml 
```

