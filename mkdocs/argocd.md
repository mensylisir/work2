##  argocd

### 部署部分

1. 创建命名空间

   ```
   kubectl create namespace argocd
   ```

2. 部署yaml文件

   ```
   kubectl apply -n argocd -f install.yaml
   ```

3. 用到的image

   ```
   192.168.80.54:8081/library/redis:5.0.10-alpine
   ```

   ```
   192.168.80.54:8081/library/argoproj/argocd:v1.7.9
   ```

   ```
   192.168.80.54:8081/library/dexidp/dex:v2.22.0
   ```

4. 制作secret

   > 1. 创建目录
   >
   >    ```
   >    mkdir cert && cd cert
   >    ```

   > 2. 生成私钥
   >
   >    ```
   >    openssl genrsa -out tls.key 2048
   >    ```
   >
   > 3. 创建自签证书
   >
   >    ```
   >    openssl req -new -x509 -key tls.key -days 10000 -out tls.crt -subj /C=CN/ST=GuangDong/L=Guangzhou/O=DevOps/CN=argocd-dev2.rdev.tech
   >    ```
   >
   > 4. 创建secret
   >
   >    ```
   >    kubectl create secret tls argocd-ingress-secret --cert=tls.crt --key=tls.key -n argocd
   >    kubectl get secret -n argocd
   >    kubectl describe secret argocd-ingress-secret -n argocd
   >    ```

5. 配置ingress

   ```
   apiVersion: extensions/v1beta1
   kind: Ingress
   metadata:
     name: argocd-server-ingress
     namespace: argocd
     annotations:
       cert-manager.io/cluster-issuer: letsencrypt-prod
       kubernetes.io/ingress.class: nginx
       kubernetes.io/tls-acme: "true"
       nginx.ingress.kubernetes.io/ssl-passthrough: "true"
   spec:
     rules:
     - host: argocd-dev.rdev.tech
       http:
         paths:
         - backend:
             serviceName: argocd-server
             servicePort: https
           path: /
     tls:
     - hosts:
       - argocd-dev.rdev.tech
       secretName: argocd-ingress-secret
   ```

6. 修改argocd-server deployment以将–insecure标志添加 到argocd-server命令

   ```yaml
   spec:
     progressDeadlineSeconds: 600
     replicas: 1
     revisionHistoryLimit: 10
     selector:
       matchLabels:
         app.kubernetes.io/name: argocd-server
     strategy:
       rollingUpdate:
         maxSurge: 25%
         maxUnavailable: 25%
       type: RollingUpdate
     template:
       metadata:
         creationTimestamp: null
         labels:
           app.kubernetes.io/name: argocd-server
       spec:
         containers:
         - command:
           - argocd-server
           - --insecure
           - --staticassets
           - /shared/app
           image: 192.168.80.54:8081/library/argoproj/argocd:v1.7.9
           imagePullPolicy: Always
           name: argocd-server
   ```

7. 编辑argocd-secret,添加密码

### keycloak统一登陆部分

1.登录keycloak服务器

```
192.168.81.104
```



2.首先，我们需要设置一个新客户端。首先登录到您的keycloak服务器，选择要使用的领域（`master`默认情况下，我们选用的是Demo），然后转到“**客户端”**并单击右上角的“**创建”**按钮

![image-20201216141442761](.\argocd.assets\image-20201216141442761.png)

3.将有效重定向URI设置为ArgoCD主机名的回调URL，应该是https：// {hostname} / auth / callback（您也可以保留默认的安全性较低的https：// {hostname} / *）。您还可以将**基本URL**设置 为*/ applications。

![image-20201216142025413](argocd.assets\image-20201216142025413.png)

4.Credentials选项卡中，可以复制将在ArgoCD配置中使用的Secret。

![image-20201216142330513](argocd.assets\image-20201216142330513.png)



#### 配置群组声明

1.为了使ArgoCD提供用户所在的组，我们需要配置可包含在身份验证令牌中的组声明。为此，我们将首先创建一个名为*groups*的新**客户范围**。

![image-20201216142448464](argocd.assets\image-20201216142448464.png)



2.创建了客户范围，现在就可以添加一个令牌映射器，当客户请求组范围时，它将把组声明添加到令牌中。确保将“**名称**”和“**令牌声明名称”设置**为*组*。

![image-20201216142702537](argocd.assets\image-20201216142702537.png)



3.现在，我们可以配置客户端以提供作用域。现在，您可以将范围**分配**给“**分配的默认客户端范围”** 或“**分配的可选客户端范围”**。如果将其放在“可选”类别中，则需要确保ArgoCD要求其OIDC配置中的作用域。

由于我们将始终需要组信息，因此我建议使用“默认”类别。确保单击**添加选定项** ，并且声明在**右侧**的正确列表中。

![image-20201216142944487](argocd.assets\image-20201216142944487.png)



创建一个名为*ArgoCDAdmins*的组，并让您的当前用户加入该组

![image-20201216143329067](argocd.assets\image-20201216143329067.png)



![image-20201216143445969](argocd.assets\image-20201216143445969.png)

#### 配置ArgoCD OIDC

将Credentials中生成的Secret存储在argocd-secret中

1.首先，需要在base64中编码客户端密码,并对编码后的密码进行保存

```
echo -n '990f12a1-339b-4ede-bf2a-be65ea0d6d7c' | base64
```

2.然后可以编辑这个argocd-secret，添加一个新密钥oidc.keycloak.clientSecret，值为上一步编码后的密码

```
kubectl edit secret argocd-secret -n argocd
```

```
oidc.keycloak.clientSecret: OTkwZjEyYTEtMzM5Yi00ZWRlLWJmMmEtYmU2NWVhMGQ2ZDdj
```

3.编辑argocd-cm,添加如下

```
kubectl edit configmap argocd-cm -n argocd
```

```
data:
  url: https://argocd-dev.rdev.tech    #改为应用的域名
  oidc.config: |
    name: Keycloak
    issuer: http://192.168.81.104/auth/realms/demo   #改为keycloakURL
    clientID: argocd
    clientSecret: $oidc.keycloak.clientSecret
    requestedScopes: ["openid", "profile", "email", "groups"]  # 如果域名不是默认的default命名空间，需要加这个参数
```

3.编辑argocd-rbac-cm,添加如下

```
kubectl edit configmap argocd-rbac-cm -n argocd 
```

```
data:
  policy.csv: |
    g, ArgoCDAdmins, role:admin
```

详情请点击<https://argoproj.github.io/argo-cd/operator-manual/user-management/keycloak/>

