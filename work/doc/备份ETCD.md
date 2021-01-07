1. https://github.com/vmware-tanzu/velero/releases



## 备份ETCD

> ### 将访问etcd所需的证书放入secret

````shell
kubectl create namespace etcdbackup
kubectl create secret tls etcd-tls --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key -n etcdbackup
kubectl create secret generic etcd-ca --from-file=/etc/kubernetes/pki/etcd/ca.crt -n etcdbackup
````

> ### **创建pvc和deploy 文件etcd-backup-cronjob.yaml**
>
> ```yaml
> apiVersion: v1
> kind: PersistentVolumeClaim
> metadata:
>   name: etcd-backup
>   namespace: etcdbackup              
> spec:
>   accessModes:
>   - ReadWriteMany
>   resources:
>     requests:
>       storage: 10Gi
>   storageClassName: "nfs-client"  
>   
> ---
> 
> apiVersion: batch/v1beta1
> kind: CronJob
> metadata:
>   namespace: etcdbackup
>   name: etcd-backup
> spec:
>   schedule: "0/3 * * * *"
>   jobTemplate:
>     spec:
>       template:
>         spec:
>           containers:
>           - name: etcd-backup
>             image: 192.168.80.54:8081/coreos/etcd:v3.3.10
>             imagePullPolicy: IfNotPresent
>             env:
>             - name: ETCD_SERVERS
>               value: https://192.168.80.79:2379,https://192.168.80.80:2379
>             - name: CERT
>               value: "--cacert=/etc/etcd/ca/ca.crt --cert=/etc/etcd/ssl/tls.crt --key=/etc/etcd/ssl/tls.key"
>             args:
>             - /bin/sh
>             - -c
>             - BACKUP_TIME=$(date +"%Y%m%d%H%M") && ETCDCTL_API=3 etcdctl snapshot save --endpoints=$ETCD_SERVERS ${CERT#]} /backup/etcd-snapshot-$BACKUP_TIME.db && tar -cvzf /backup/etcd-snapshot-$BACKUP_TIME.db.tar.gz /backup/etcd-snapshot-$BACKUP_TIME.db && sleep 2 && rm -rf /backup/etcd-snapshot-$BACKUP_TIME.db
>             volumeMounts:
>             - mountPath: /backup
>               name: etcd-backup
>             - mountPath: /etc/etcd/ssl/
>               name: etcd-tls
>             - mountPath: /etc/etcd/ca/
>               name: etcd-ca
>           volumes:
>           - name: etcd-tls
>             secret:
>               secretName: etcd-tls
>           - name: etcd-ca
>             secret:
>               secretName: etcd-ca
>           - name: etcd-backup
>             persistentVolumeClaim:
>               claimName: etcd-backup
>           restartPolicy: OnFailure 
> ```
>

## shell脚本备份

```
ETCDCTL_API=3 /usr/local/bin/etcdctl --endpoints=https://192.168.80.79:2379 --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key --cacert=/etc/kubernetes/pki/etcd/ca.crt snapshot save /opt/k8s_backup/etcd/$(date +%F%H%M%S)-k8s-snapshot.db
```

```

```

```
ETCDCTL_API=3 /usr/local/bin/etcdctl \
 --endpoints="https://192.168.80.84:2379,https://192.168.80.85:2379" \
 --cert=/etc/kubernetes/pki/etcd/server.crt \
 --key=/etc/kubernetes/pki/etcd/server.key \
 --cacert=/etc/kubernetes/pki/etcd/ca.crt  \
 --initial-advertise-peer-urls https://192.168.80.84:2380 \
 --initial-cluster-token=etcd-cluster-token \
 --initial-cluster=etcd-app-master-2=https://192.168.80.84:2380,etcd-app-master-1=https://192.168.80.85:2380 \
 snapshot restore /opt/etcd/2020-12-11163541-k8s-snapshot.db \
 --data-dir=/var/lib/etcd/ \
 --name etcd-app-master-2
```

```
ETCDCTL_API=3 /usr/local/bin/etcdctl \
 --endpoints="https://192.168.80.84:2379,https://192.168.80.85:2379" \
 --cert=/etc/kubernetes/pki/etcd/server.crt \
 --key=/etc/kubernetes/pki/etcd/server.key \
 --cacert=/etc/kubernetes/pki/etcd/ca.crt  \
 --initial-advertise-peer-urls https://192.168.80.85:2380 \
 --initial-cluster-token=etcd-cluster-token \
 --initial-cluster=etcd-app-master-2=https://192.168.80.84:2380,etcd-app-master-1=https://192.168.80.85:2380 \
 snapshot restore /opt/etcd/2020-12-11163541-k8s-snapshot.db \
 --data-dir=/var/lib/etcd/ \
 --name etcd-app-master-1
```

