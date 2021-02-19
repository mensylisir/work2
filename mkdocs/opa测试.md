

登录79服务器，规则部署再master

```
vim opa_ingress.yaml
```

#### 1.下面为opa_ingress.yaml 的内容

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: opa-ingress
  namespace: zjk
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  tls:
    - hosts:
        - opa-dev88.rdev.tech
      secretName: argocd-ingress-secret
  rules:
    - host: opa-dev88.rdev.tech
      http:
        paths:
          - pathType: ImplementationSpecific
            backend:
              serviceName: inner
              servicePort: 8001
```



#### 2.部署yaml文件,执行如下命令后出现报错为正常 

```
kubectl apply -n zjk -f opa_ingress.yaml
```

#### 3.重新编辑zjk

```
kubectl edit ns zjk
```

在metadata下行添加如下信息：

```
  annotations:
    ingress-whitelist: "*.rdev.tech"
```

#### 4. 添加成功后重新部署

```
kubectl apply -n zjk -f opa_ingress.yaml
```

命令行执行后，无报错为正常

![image-20210107143931403](opa%E6%B5%8B%E8%AF%95.assets/image-20210107143931403.png)