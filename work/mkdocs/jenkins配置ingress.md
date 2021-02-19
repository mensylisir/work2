## jenkins配置ingress

```
kind: Ingress
apiVersion: extensions/v1beta1
metadata:
  name: jenkins
  namespace: jenkins
  labels:
    app: gitlab
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
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
    secretName: jenkins-tls-pem
```

