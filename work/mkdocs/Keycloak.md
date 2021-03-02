

### 需要用到的镜像

```shell
docker push 192.168.80.54:8081/library/argoproj/argocd:v1.8.0
docker push 192.168.80.54:8081/library/redis:5.0.10-alpine
docker push 192.168.80.54:8081/library/dexidp/dex:v2.25.0
docker push 192.168.80.54:8081/library/rf/gerrit-saml 
docker push 192.168.80.54:8081/library/gerritcodereview/gerrit:latest
docker push 192.168.80.54:8081/library/sonatype/nexus3:3.20.1
docker push 192.168.80.54:8081/library/bitnami/postgresql:11.6.0-debian-10-r0
docker push 192.168.80.54:8081/library/jboss/keycloak
docker push 192.168.80.54:8081/library/bitnami/postgresql:11.6.0-debian-10-r0
docker pull 192.168.80.54:8081/library/gitlab/gitlab-ce:9.4.1-ce.0
docker pull 192.168.80.54:8081/library/postgres:9.6
docker pull 192.168.80.54:8081/bitnami/redis:3.2.9-r2
```

### 准备工作

```shell
mkdir /opt/pgdata
```

```shell
docker network create keycloak-network
```

### docker启动pg数据库

```shell
docker run -d --net keycloak-network --name postgres -v /data/pgdata:/var/lib/postgresql/data -e POSTGRES_DB=keycloak -e POSTGRES_USER=keycloak -e POSTGRES_PASSWORD=password -e PGDATA=/var/lib/postgresql/data/pgdata  192.168.80.54:8081/library/bitnami/postgresql:11.6.0-debian-10-r0
```

### docker启动Keycloak

```shell
docker run -d --net keycloak-network --name keycloak -p 8080:8080 -e DB_ADDR=postgres -e DB_USER=keycloak -e DB_PASSWORD=password -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin 192.168.80.54:8081/library/jboss/keycloak
```

```shell
docker run -d --net keycloak-network --name keycloak -p 80:8080 -p 443:8443 -p 9990:9990 -e TZ=Asia/Shanghai --privileged=true   -e DB_ADDR=postgres -e DB_USER=keycloak -e DB_PASSWORD=password -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin   -v /etc/localtime:/etc/localtime  192.168.80.54:8081/library/jboss/keycloak
```

```shell
docker run -d --net keycloak-network --name keycloak1 -p 81:8080 -p 444:8443 -p 9991:9990 -e TZ=Asia/Shanghai --privileged=true   -e DB_ADDR=postgres -e DB_USER=keycloak  -v /etc/localtime:/etc/localtime  192.168.80.54:8081/library/jboss/keycloak
```

```shell
docker run -d --net keycloak-network --name keycloak -p 80:8080 -p 443:8443 -p 9990:9990 -e TZ=Asia/Shanghai --privileged=true   -e DB_ADDR=postgres -e DB_USER=keycloak -e DB_PASSWORD=password -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=Def@u1tpwd   -v /etc/localtime:/etc/localtime  192.168.80.54:8081/library/jboss/keycloak
```



### 对接jenkins

详见官方文档，请点击[这里](https://plugins.jenkins.io/keycloak/)

### 对接gitlab

详见[这里](https://edenmal.moe/post/2018/GitLab-Keycloak-SAML-2-0-OmniAuth-Provider/?__cf_chl_captcha_tk__=8e4294f285dd752bfc60e361d42daebf5405c098-1607397759-0-AYnddQh_TBiG911wm9YucmksaX6yIZ-35vhYHhwvMbFtPnZvJdl6mjbG1ztGi7FpCzrUJYZpzsjbjfIcitpIVnaQeiMYCqwZv55U4DuGCndOX6ey-GeLs28PcGLxnFIjRUTRCBG15NivT2pI-9eAApffPh1Ub_wj5YHKBZq97mB99eTUSAAwiravm1VAc6VIIwVu2O_BOZSz8is5fUoM0sSSm4yoeVJ4uXhlAG9f9vS7tvC6L1ADrkWrt1J6xyudMHMwld28dKjpaUdq6Wn_1aJLTNJI_G88QETskbbxze0HbmxFUJZfhIx_quci8W9tiDq9xfMl5E_MTEUA-k-sczSoiBGS0YLlA9KnuUAJHMI-jwqtuW8MeVSN9tPHo_oEqSVRhu_46ZYYxmc0YdTquz0nuqCyhkmBu9GVoqwdaDdUTHy4uf-cKuf2ytCouF0QNl8m4RZZOlDjmCni8K41N29iHMWEBZpORbxczv-JvJMqa38zXYD5JBcHmb_4OOBYpTmmFVqF4EZbmCIqzul3dn6Z3snZO5hBR4xSRF2RMarKTP5xveMMp_vmP4sBxiXyebfNeUn7R5Btq88fl3i2uPg)

```
(
    echo "-----BEGIN CERTIFICATE-----"
    grep -oP '<ds:X509Certificate>(.*)</ds:X509Certificate>' "descriptor1.xml" | sed -r -e 's~<[/]?ds:X509Certificate>~~g' | fold -w 64
    echo "-----END CERTIFICATE-----"
) | openssl x509 -noout -fingerprint -sha1
```

### 对接nexus

#### keycloak端

![image-20201218151343110](Keycloak.assets/image-20201218151343110-1608279945652.png)

![image-20201218151422621](Keycloak.assets/image-20201218151422621-1608279950250.png)

![image-20201218151545618](Keycloak.assets/image-20201218151545618-1608279955481.png)

#### nexus端

1. 在Settings->Security->Realms做如下设置

   ![image-20201218151050860](Keycloak.assets/image-20201218151050860-1608279960502.png)

2. 在Settings->Security->Roles做如下设置

   ![image-20201218151118907](Keycloak.assets/image-20201218151118907-1608279982829.png)

​      ![image-20201218151142259](Keycloak.assets/image-20201218151142259-1608279988335.png)

### harbor

OIDC客户端密码从图二获取

![image-20201224113338802](Keycloak.assets/image-20201224113338802.png)

![image-20201224113412002](Keycloak.assets/image-20201224113412002.png)

![image-20201224113551494](Keycloak.assets/image-20201224113551494.png)



认证方式无法选择是由于数据库中已经新建了用户。默认就只能是数据库了，需要先删除数据库中用户

```
docker exec -it harbor-db bash 
psql 
\c registry #切换进入表格
select * from harbor_user; 查看用户
delete from harbor_user where user_id=3; #删除用户3
select * from harbor_user;

```

第一次查询用户（第三个是新建的）

```
 user_id | username  |       email        |             password             |    realname    |    comment     | deleted | reset_uuid |    
           salt               | sysadmin_flag |       creation_time        |        update_time         | password_version 
---------+-----------+--------------------+----------------------------------+----------------+----------------+---------+------------+----
------------------------------+---------------+----------------------------+----------------------------+------------------
       2 | anonymous |                    |                                  | anonymous user | anonymous user | t       |            |    
                              | f             | 2020-12-17 02:43:44.627351 | 2020-12-17 02:43:45.338084 | sha1
       1 | admin     |                    | 29cae2578889207481993fe1031806a7 | system admin   | admin user     | f       |            | bq5
5pneoj8nz5a1f9u7l8hn4vi7cvp9o | t             | 2020-12-17 02:43:44.627351 | 2020-12-17 02:43:45.553498 | sha256
       3 | ocp#3     | ocp4@example.com#3 | 4204bfab7e32495a0c4d32b3d3d69302 | ocp            |                | t       |            | tNm
eBSarduRwyQmmQFoYBH6PKwi2Fb7d | f             | 2020-12-24 02:40:16        | 2020-12-24 02:57:40.547793 | sha256
(3 rows)
```

第二次查询用户，成功删除用户3

```
 user_id | username  | email |             password             |    realname    |    comment     | deleted | reset_uuid |               sa
lt               | sysadmin_flag |       creation_time        |        update_time         | password_version 
---------+-----------+-------+----------------------------------+----------------+----------------+---------+------------+-----------------
-----------------+---------------+----------------------------+----------------------------+------------------
       2 | anonymous |       |                                  | anonymous user | anonymous user | t       |            |                 
                 | f             | 2020-12-17 02:43:44.627351 | 2020-12-17 02:43:45.338084 | sha1
       1 | admin     |       | 29cae2578889207481993fe1031806a7 | system admin   | admin user     | f       |            | bq55pneoj8nz5a1f
9u7l8hn4vi7cvp9o | t             | 2020-12-17 02:43:44.627351 | 2020-12-17 02:43:45.553498 | sha256
(2 rows)
```