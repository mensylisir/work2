### NFS

#### NFS安装

##### Server端

- 安装

  ```
  yum install nfs-utils
  ```

- 配置

  - 创建目录

    ```
    mkdir -p /data/nfsmount
    chmod -R 777 /data/nfsmount
    ```

  - 配置

    ```
    # cat /etc/exports
    /data/nfsmount *(rw,sync,no_root_squash)
    ```

- 启用

  ```
  systemctl restart nfs
  systemctl enable nfs
  ```

##### Client端

```
yum install nfs-utils # 所有的k8s worker节点都需要安装
```

#### 部署nfs服务

注意修改nfs-server的ip和目录

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: nfs-client
provisioner: nfs
reclaimPolicy: Delete
volumeBindingMode: Immediate
---
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nfs-client-provisioner
  # replace with namespace where provisioner is deployed
  namespace: kube-system
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: nfs-client-provisioner-runner
rules:
  - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get", "list", "watch", "create", "delete"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch", "update"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["create", "update", "patch"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: run-nfs-client-provisioner
subjects:
  - kind: ServiceAccount
    name: nfs-client-provisioner
    # replace with namespace where provisioner is deployed
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: nfs-client-provisioner-runner
  apiGroup: rbac.authorization.k8s.io
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  # replace with namespace where provisioner is deployed
  namespace: kube-system
rules:
  - apiGroups: [""]
    resources: ["endpoints"]
    verbs: ["get", "list", "watch", "create", "update", "patch"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  # replace with namespace where provisioner is deployed
  namespace: kube-system
subjects:
  - kind: ServiceAccount
    name: nfs-client-provisioner
    # replace with namespace where provisioner is deployed
    namespace: kube-system
roleRef:
  kind: Role
  name: leader-locking-nfs-client-provisioner
  apiGroup: rbac.authorization.k8s.io

---
kind: Deployment
apiVersion: apps/v1
metadata:
  name: nfs-client-provisioner
  namespace: kube-system
spec:
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nfs-client-provisioner
  template:
    metadata:
      labels:
        app: nfs-client-provisioner
    spec:
      serviceAccountName: nfs-client-provisioner
      containers:
        - name: nfs-client-provisioner
          image: 192.168.80.54:8081/external_storage/nfs-client-provisioner:latest
          volumeMounts:
            - name: nfs-client-root
              mountPath: /persistentvolumes
          env:
            - name: PROVISIONER_NAME
              value: nfs      
            - name: NFS_SERVER
              value: 192.168.81.105
            - name: NFS_PATH
              value: /data/nfsmount 
      volumes:
        - name: nfs-client-root
          nfs:
            server: 192.168.81.105
            path: /data/nfsmount
```

#### 验证nfs

```yaml
# with-pv.yaml
# Copyright 2017 the Velero contributors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

---
apiVersion: v1
kind: Namespace
metadata:
  name: nginx-example
  labels:
    app: nginx

---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: nginx-logs
  namespace: nginx-example
  labels:
    app: nginx
spec:
  Optional:
  storageClassName: 'nfs-client'
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 50Mi

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: nginx-example
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
      annotations:
        pre.hook.backup.velero.io/container: fsfreeze
        pre.hook.backup.velero.io/command: '["/sbin/fsfreeze", "--freeze", "/var/log/nginx"]'
        post.hook.backup.velero.io/container: fsfreeze
        post.hook.backup.velero.io/command: '["/sbin/fsfreeze", "--unfreeze", "/var/log/nginx"]'
    spec:
      volumes:
        - name: nginx-logs
          persistentVolumeClaim:
           claimName: nginx-logs
      containers:
      - image: 192.168.80.54:8081/library/nginx:1.17
        name: nginx
        ports:
        - containerPort: 80
        volumeMounts:
          - mountPath: "/var/log/nginx"
            name: nginx-logs
            readOnly: false
      - image: 192.168.80.54:8081/library/ubuntu:bionic
        name: fsfreeze
        securityContext:
          privileged: true
        volumeMounts:
          - mountPath: "/var/log/nginx"
            name: nginx-logs
            readOnly: false
        command:
          - "/bin/bash"
          - "-c"
          - "sleep infinity"
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: nginx
  name: my-nginx
  namespace: nginx-example
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: nginx
  type: NodePort
```

```
kubectl apply -f with-pv.yaml
```

```yaml
[root@app-master-2 nginx-app]# kubectl get pod -n nginx-example
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-64f6fbc76-8sx7k   2/2     Running   0          177m
[root@app-master-2 nginx-app]# kubectl get pvc -n nginx-example   
NAME         STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
nginx-logs   Bound    pvc-5c82be5b-b140-46e9-8967-cdc80b63bebc   50Mi       RWO            nfs-client-3   177m
[root@app-master-2 nginx-app]# kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                       STORAGECLASS   REASON   AGE
pvc-5c82be5b-b140-46e9-8967-cdc80b63bebc   50Mi       RWO            Delete           Bound    nginx-example/nginx-logs    nfs-client-3            177m
pvc-81b2c8d8-c8a3-41ff-b9b9-991651d32dcf   50Mi       RWO            Delete           Bound    nginx-example2/nginx-logs   nfs-client-4            172m
[root@app-master-2 nginx-app]# kubectl get pv pvc-5c82be5b-b140-46e9-8967-cdc80b63bebc -o yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  annotations:
    pv.kubernetes.io/provisioned-by: cluster.local/nfs-client-3-nfs-client-provisioner
  creationTimestamp: "2020-12-22T03:07:49Z"
  finalizers:
  - kubernetes.io/pv-protection
  managedFields:
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:status:
        f:phase: {}
    manager: kube-controller-manager
    operation: Update
    time: "2020-12-22T03:07:49Z"
  - apiVersion: v1
    fieldsType: FieldsV1
    fieldsV1:
      f:metadata:
        f:annotations:
          .: {}
          f:pv.kubernetes.io/provisioned-by: {}
      f:spec:
        f:accessModes: {}
        f:capacity:
          .: {}
          f:storage: {}
        f:claimRef:
          .: {}
          f:apiVersion: {}
          f:kind: {}
          f:name: {}
          f:namespace: {}
          f:resourceVersion: {}
          f:uid: {}
        f:nfs:
          .: {}
          f:path: {}
          f:server: {}
        f:persistentVolumeReclaimPolicy: {}
        f:storageClassName: {}
        f:volumeMode: {}
    manager: nfs-client-provisioner
    operation: Update
    time: "2020-12-22T03:07:49Z"
  name: pvc-5c82be5b-b140-46e9-8967-cdc80b63bebc
  resourceVersion: "226580"
  selfLink: /api/v1/persistentvolumes/pvc-5c82be5b-b140-46e9-8967-cdc80b63bebc
  uid: 03edbda2-e012-4403-ad3d-da166321b74e
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 50Mi
  claimRef:
    apiVersion: v1
    kind: PersistentVolumeClaim
    name: nginx-logs
    namespace: nginx-example
    resourceVersion: "226567"
    uid: 5c82be5b-b140-46e9-8967-cdc80b63bebc
  nfs:
    path: /data/nfsmount/nginx-example-nginx-logs-pvc-5c82be5b-b140-46e9-8967-cdc80b63bebc
    server: 192.168.81.105
  persistentVolumeReclaimPolicy: Delete
  storageClassName: nfs-client-3
  volumeMode: Filesystem
status:
  phase: Bound
```

查看pv里面的server为192.168.81.105，则OK

然后登录192.168.81.105，查看是否存在/data/nfsmount/nginx-example-nginx-logs-pvc-5c82be5b-b140-46e9-8967-cdc80b63bebc



##### 集群外挂载：

```
1 去nfs服务器创建目录并添加777权限
cd /opt/mountnfs;mkdir harbor-1921688078;chmod +777 harbor-1921688078;#在nfs服务器192.168.81.105操作
2 安装nfs 客户端 (客户端执行)
yum install nfs-utils # 所有的k8s worker节点都需要安装
mkdir -p /opt/data;mount -t nfs 192.168.81.105:/data/nfsmount/harbor-1921688078 /opt/data
```

 

