## ingress + https

# 生成Cert

## 1. 安装cfssl

## 2. 准备CA

> 1. 获取ca.pem和ca-key.pem
>
> 2. 获取ca-config.json
>
> 3. 修改jenkins-csr.json
>
>    ```json
>    {
>        "hosts": [
>            "jenkins-dev.rdev.tech"
>        ],
>        "key": {
>            "algo": "ecdsa",
>            "size": 256
>        },
>        "names": [
>            {
>                "C": "CN",
>                "ST": "beijing",
>                "L": "haidian",
>                "O": "Cars",
>                "OU": "ICT"
>            }
>        ]
>    }
>    ```
>
>    

> 4. 生成证书
>
>    ```shell
>    cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www jenkins-csr.json | cfssljson -bare jenkins-dev
>    ```

## 3. 创建k8s证书

```
kubectl create secret tls jenkins-dev-tls-pem -n jenkins --cert=jenkins-dev.pem --key=jenkins-dev-key.pem --dry-run -o yaml > jenkins-dev-tls.yaml
kubectl apply -f jenkins-dev-tls.yaml
```

### 4. 查看jenkins的svc名称和端口

```
[root@jenkins-master-1 ~]# kubectl get svc -n jenkins
NAME       TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)                          AGE
jenkins    NodePort   179.20.195.223   <none>        8080:31888/TCP,50000:31999/TCP   16d
postgres   NodePort   179.20.183.53    <none>        5432:31317/TCP                   14d
sonar      NodePort   179.20.181.124   <none>        9000:30001/TCP                   14d
```

### 5. jenkins_ingress

```
kind: Ingress
apiVersion: extensions/v1beta1
metadata:
  name: jenkins
  namespace: jenkins
  labels:
    app: jenkins
  annotations:
    nginx.ingress.kubernetes.io/secure-backends: 'true'
    nginx.ingress.kubernetes.io/ssl-passthrough: 'true'
spec:
  rules:
    - host: jenkins-dev.rdev.tech
      http:
        paths:
          - path: /
            backend:
              serviceName: jenkins
              servicePort: 8080
  tls:
  - hosts:
    - jenkins-dev.rdev.tech
    secretName: jenkins-dev-tls-pem

```

