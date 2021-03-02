```
docker run --name
```

```
docker run --name
```



###  迁移并且切换nfs



```
参考redmine
```



#  添加域名和https



```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: metersphere
  namespace: dev
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: 50m
spec:
  rules:
  - host: testp.dev.rdev.tech
    http:
      paths:
      - backend:
          serviceName: metersphere
          servicePort: 80
  tls:
  - hosts:
    - testp.dev.rdev.tech
    secretName: metersphere-dev-tls-pem
---
apiVersion: v1
kind: Endpoints
metadata:
  name: metersphere
  namespace: dev
subsets:
  - addresses:
      - ip: 192.168.80.89
    ports:
      - port: 8081

---
apiVersion: v1
kind: Service
metadata:
  name: metersphere
  namespace: dev
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8081
```



```
#生成cert
kubectl create secret tls metersphere-dev-tls-pem -n dev --cert=metersphere-dev.pem --key=metersphere-dev-key.pem --dry-run -o yaml > metersphere-dev-tls.yaml
kubectl apply -f metersphere-dev-tls.yaml
```



### dns

```

```



## 





