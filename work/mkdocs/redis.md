###  在项目部署集群的namespace内部署



```
1 现在nfs创建目录，/data/nfsmount/redis-rmmis-dev，然后修改yaml后部署

2 redis.yaml
##创建PV
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis-rmmis-pv         #注释部分为需要按照项目修改后删除注释部分rmmis改为namespace
  namespace: rmmis-dev         #rmmis-dev改为namespace
  labels:
    pv: redis-rmmis-pv         #rmmis改为namespace
spec:
  capacity:
    storage: 5Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: "nfs-client-3"
  nfs:
    server: 192.168.81.105
    path: /data/nfsmount/redis-rmmis-dev    #redis-rmmis-dev按照项目名称创建目录后修改此处

##创建pvc
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: redis-rmmis-pvc     #rmmis改为namespace
  namespace: rmmis-dev      #rmmis-dev改为namespace
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  selector:
    matchLabels:
      pv: redis-rmmis-pv   #rmmis改为namespace
## 部署redis
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: redis
  name: redis
  namespace: rmmis-dev     #rmmis-dev改为namespace 
spec:
  replicas: 1
  selector:
    matchLabels:
      name: redis
  template:
    metadata:
      labels:
        name: redis
    spec:
      containers:
      - name: redis
        image: harbor.dev.rdev.tech/library/redis:5.0.5-alpine
        volumeMounts:
        - name: redis-rmmis     #rmmis改为namespace
          mountPath: "/data"
        command:
          - "redis-server"
      volumes:
      - name: redis-rmmis       #rmmis改为namespace
        persistentVolumeClaim:
          claimName: redis-rmmis-pvc  #rmmis改为namespace
##创建Service
---
apiVersion: v1
kind: Service
metadata:
  name: redis-rmmis              #rmmis改为namespace
  namespace: rmmis-dev           #rmmis-dev改为namespace 
  labels: 
    name: redis
spec:
  type: NodePort
  ports:
  - port: 6379
    protocol: TCP
    targetPort: 6379
    name: http
  selector: 
    name: redis
```

