### 启动

---

docker run -d --restart=always --name wekan-db -p 27017:27017 -v /opt/wekan/mongo/configdb:/data/configdb -v  /opt/wekan/mongo/db:/data/db 192.168.80.54:8081/bitnami/mongo:latest

docker run -d --restart=always --name wekan --link "wekan-db:db" -e "WITH_API=true" -e "MONGO_URL=mongodb://wekan-db:27017/wekan" -e "ROOT_URL=http://192.168.80.89:2000" -p 2000:8080 192.168.80.54:8081/wekan/wekan



### 切换本地存储到nfs



> > ```
> > #先停wekan，在停wekan-db
> > docker stop wekan
> > docker stop wekan-db
> > #备份数据
> > cd /opt/wekan
> > mv mongo mongo_bak
> > #在nfs服务器执行，创建目录并添加777权限
> > mkdir wekan-db-1921688089-20210125
> > chmod +777 wekan-db-1921688089-20210125
> > #客户端执行，安装nfs客户端
> > yum install nfs-utils
> > mkdir -p /opt/wekan/mongo;mount -t nfs 192.168.81.105:/data/nfsmount/wekan-db-1921688089-20210125 /opt/wekan/mongo
> > #把数据拷贝到nfs目录
> > cp -rf mongo_bak/* mongo/
> > #启动docker恢复服务，先启动wekan-db，在启动wekan
> > docker start wekan-db
> > docker start wekan
> > 
> > ingress.yaml内容：
> > apiVersion: extensions/v1beta1
> > kind: Ingress
> > metadata:
> >   name: wekan
> >   namespace: dev
> >   annotations:
> >     nginx.ingress.kubernetes.io/proxy-body-size: 50m
> > spec:
> >   rules:
> >   - host: wekan.dev.rdev.tech
> >     http:
> >       paths:
> >       - backend:
> >           serviceName: wekan
> >           servicePort: 80
> > ---
> > apiVersion: v1
> > kind: Endpoints
> > metadata:
> >   name: wekan
> >   namespace: dev
> > subsets:
> >   - addresses:
> >       - ip: 192.168.80.89
> >     ports:
> >       - port: 2000
> > 
> > ---
> > apiVersion: v1
> > kind: Service
> > metadata:
> >   name: wekan
> >   namespace: dev
> > spec:
> >   ports:
> >     - protocol: TCP
> >       port: 80
> >       targetPort: 2000
> > ```
> >

