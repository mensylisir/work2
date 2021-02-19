```
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: / #重写路径
    nginx.ingress.kubernetes.io/ssl-redirect: 'true' #http 自动转https
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "600" #修改代理超时时间，默认是60s
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
```

