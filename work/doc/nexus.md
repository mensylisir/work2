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
   docker run -d  --name nexus3 -p 8081:8081 -p 8082:8082 -p 8083:8083 -e TZ=Asia/Shanghai --privileged=true --restart=always -v /etc/localtime:/etc/localtime -v  /opt/nexus/data:/nexus-data    -v /opt/sonatype/nexus/deploy/nexus3-keycloak-plugin-0.4.1-SNAPSHOT-bundle.kar:/opt/sonatype/nexus/deploy/nexus3-keycloak-plugin-0.4.1-SNAPSHOT-bundle.kar -v /opt/sonatype/nexus/etc/keycloak.json:/opt/sonatype/nexus/etc/keycloak.json192.168.80.54:8081/library/sonatype/nexus3:v1.0.0_alpha
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
docker cp nexus3-keycloak-plugin-0.4.1-SNAPSHOT-bundle.kar nexus_install_nexus_1:/opt/sonatype/nexus/deploy
```

```
docker cp keycloak.json nexus_install_nexus_1:/opt/sonatype/nexus/etc/
```