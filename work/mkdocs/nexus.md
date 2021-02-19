1. pull sonatype/nexus3

   ```
   docker pull sonatype/nexus3
   ```

2. change tag

   ```
   docker tag sonatype/nexus3 192.168.80.54:8081/library/sonatype/nexus3:v1.0.0_alpha
   ```

3. push

   ```
   docker push 192.168.80.54:8081/library/sonatype/nexus3:v1.0.0_alpha
   ```

4. docker-compose.yaml

   ```yaml
   version: "2"
   
   services:
     nexus:
       image: 192.168.80.54:8081/library/sonatype/nexus3:v1.0.0_alpha
       restart: always
       volumes:
         - "/opt/nexus/data:/nexus-data"
         - "/etc/localtime:/etc/localtime"
       ports:
         - "8081:8081"
     
   volumes:
     nexus-data: {}
   ```

   ```yaml
   
   ```
   
   ```

   ```
   
5. add privileges

   ```
   chmod +x /opt/nexus/data
   ```

6. start

   ```
   docker-compose up
   ```


7. enter docker container

   ```
   docker exec -it #容器id /bin/bash
   ```

8. view password

   ```
   cat /nexus-data/admin.password
   ```

9. login

   ```
   http://192.168.80.77:8081/
   ```




### 对接keycloak

点击[这里](https://github.com/flytreeleft/nexus3-keycloak-plugin)

```
docker cp /opt/nexus_install/nexus3-keycloak-plugin-0.4.1-SNAPSHOT-bundle.kar nexus_install_nexus_1:/opt/sonatype/nexus/deploy

docker cp /opt/nexus_install/nexus3-keycloak-plugin-0.4.1-SNAPSHOT-bundle.kar nexus3:/opt/sonatype/nexus/deploy
```

```
docker cp /opt/nexus_install/keycloak.json nexus_install_nexus_1:/opt/sonatype/nexus/etc/

docker cp /opt/nexus_install/keycloak.json nexus3:/opt/sonatype/nexus/etc/
```



### npm下载失败401

```
#查看npm config list是否有之前配置影响，只保留第一行

```



### nexus添加https

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: nexus
  namespace: dev
spec:
  rules:
  - host: nexus-dev.rdev.tech
    http:
      paths:
      - backend:
          serviceName: nexus
          servicePort: 80
  tls:
  - hosts:
    - nexus-dev.rdev.tech
    secretName: nexus-dev-tls-pem
---        
apiVersion: v1
kind: Endpoints
metadata:
  name: nexus
  namespace: dev
subsets:
  - addresses:
      - ip: 192.168.81.20
    ports:
      - port: 8081

---
apiVersion: v1
kind: Service
metadata:
  name: nexus
  namespace: dev
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8081
```



### nexus 挂载nfs和自动挂载



```
1 去nfs服务器创建目录并添加777权限
cd /opt/mountnfs;mkdir nexus-101-20210120;chmod +777 nexus-101-20210120;#在nfs服务器192.168.81.105操作
2 安装nfs 客户端 (客户端执行)
yum install nfs-utils # 所有的k8s worker节点都需要安装
mkdir -p /opt/data;mount -t nfs 192.168.81.105:/data/nfsmount/nexus-101-20210120 /opt/nexus/data

```



### 启动添加代理

```
docker run -d  --name nexus3 -p 8081:8081 -p 8082:8082 -p 8083:8083 -e TZ=Asia/Shanghai -e https_proxy=192.168.80.11:8443 -e http_proxy=192.168.80.11:8443 --privileged=true --restart=always -v /etc/localtime:/etc/localtime -v  /opt/nexus/data:/nexus-data    -v /opt/sonatype/nexus/deploy/nexus3-keycloak-plugin-0.4.1-SNAPSHOT-bundle.kar:/opt/sonatype/nexus/deploy/nexus3-keycloak-plugin-0.4.1-SNAPSHOT-bundle.kar -v /opt/sonatype/nexus/etc/keycloak.json:/opt/sonatype/nexus/etc/keycloak.json192.168.80.54:8081/library/sonatype/nexus3:v1.0.0_alpha


```

