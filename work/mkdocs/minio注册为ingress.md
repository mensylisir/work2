### 外部minio注册为ingress

```
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    ingress-whitelist: "*.rdev.tech"
  name: minio
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: minio
spec:
  rules:
  - host: minio-dev.rdev.tech
    http:
      paths:
      - backend:
          serviceName: minio
          servicePort: 80
---
apiVersion: v1
kind: Endpoints
metadata:
  name: minio
subsets:
  - addresses:
      - ip: 192.168.80.86
      - ip: 192.168.80.87
      - ip: 192.168.80.88
    ports:
      - port: 9000

---
apiVersion: v1
kind: Service
metadata:
  name: minio
spec:
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9000
```

