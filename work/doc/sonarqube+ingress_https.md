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
>            "sonarqube-dev.rdev.tech"
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
> 4. 将cfssl下的bin加到环境变量path中
>
>    直接用命令行
>
>    ```
>    export PATH="/mnt/d/works/work/myK8s/sonarqube+ingress+https/cfssl/bin:$PATH"
>    ```

> 4. 进入到包含sonarqube-csr文件的目录下生成证书
>
>    ```shell
>    cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www sonarqube-csr.json | cfssljson -bare sonarqube-dev
>    ```

## 3. 创建k8s证书

```
kubectl create secret tls sonarqube-dev-tls-pem -n default --cert=sonarqube-dev.pem --key=sonarqube-dev-key.pem --dry-run -o yaml > sonarqube-dev-tls.yaml -n jenkins
kubectl apply -f sonarqube-dev-tls.yaml
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
  name: sonarqube
  namespace: jenkins
  labels:
    app: sonarqube
  annotations:
    nginx.ingress.kubernetes.io/secure-backends: 'true'
    nginx.ingress.kubernetes.io/ssl-passthrough: 'true'
spec:
  rules:
    - host: sonarqube-dev.rdev.tech
      http:
        paths:
          - path: /
            backend:
              serviceName: sonar   #这个不能改为sonarqube
              servicePort: 9000    
  tls:
  - hosts:
    - sonarqube-dev.rdev.tech
    secretName: sonarqube-dev-tls-pem

```

