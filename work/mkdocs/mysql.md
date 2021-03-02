### 在项目部署集群的namespace内部署



```
1 现在nfs创建目录，/data/nfsmount/mysql-imis-cyber-security，然后修改yaml后部署

2 mysql.yaml
##创建PV
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-imis-pv
  namespace: imis-cyber-security
  labels:
    pv: mysql-imis-pv
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 5Gi
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: "nfs-client-3"
  nfs:
    server: 192.168.81.105
    path: /data/nfsmount/mysql-imis-cyber-security

##创建pvc
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-imis-pvc
  namespace: imis-cyber-security
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  selector:
    matchLabels:
      pv: mysql-imis-pv
## 部署mysql
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-imis-config
  namespace: imis-cyber-security
  labels:
    app: mysql-imis-config
data:
  my.cnf: |-
    [client]
    default-character-set=utf8mb4
    [mysql]
    default-character-set=utf8mb4
    [mysqld] 
    character-set-server = utf8mb4  
    collation-server = utf8mb4_unicode_ci  
    init_connect='SET NAMES utf8mb4'  
    skip-character-set-client-handshake = true  
    max_connections=2000
    secure_file_priv=/var/lib/mysql
    bind-address=0.0.0.0
    symbolic-links=0
    sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION'
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-imis
  namespace: imis-cyber-security
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql-imis
  template:
    metadata:
      labels:
        app: mysql-imis
    spec:
      containers:
      - args:
        - --datadir
        - /var/lib/mysql/datadir
        env:
          - name: MYSQL_ROOT_PASSWORD
            value: root
          - name: MYSQL_USER
            value: user
          - name: MYSQL_PASSWORD
            value: user
        image: harbor.dev.rdev.tech/library/mysql:5.7
        name: mysql-imis
        ports:
        - containerPort: 3306
          name: dbapi
        volumeMounts:
        - mountPath: /var/lib/mysql
          name: mysql-imis
        - name: config
          mountPath: /etc/mysql/conf.d/my.cnf
          subPath: my.cnf
      volumes:
      - name: mysql-imis
        persistentVolumeClaim:
          claimName: mysql-imis-pvc
      - name: config      
        configMap:
          name: mysql-imis-config
      - name: localtime
        hostPath:
          type: File
          path: /etc/localtime
---

apiVersion: v1
kind: Service
metadata:
  labels:
    app: mysql-imis
  name: mysql-imis
  namespace: imis-cyber-security
spec:
  type: NodePort
  ports:
  - name: http
    port: 3306
    protocol: TCP
    targetPort: 3306
  selector:
    app: model-mysql
```

