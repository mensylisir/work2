







```
mkdir -p /opt/coredns/etcd-data
```

```
docker run -d \
  --restart always \
  -p 2379:2379 \
  -p 2380:2380 \
  --volume=/opt/coredns/etcd-data:/etcd-data \
  --name etcd 192.168.80.54:8081/coreos/etcd:v3.3.10 \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data \
  --name node1 \
  --initial-advertise-peer-urls http://0.0.0.0:2380 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://0.0.0.0:2379 \
  --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster node1=http://0.0.0.0:2380
```

```
mkdir -p /opt/coredns/coredns
touch /opt/coredns/coredns/hosts
touch /opt/coredns/coredns/Corefile
```

```
docker run -d \
  --restart always \
  --name coredns \
  -p 53:53/tcp \
  -p 53:53/udp \
  -v /opt/coredns/coredns/hosts:/etc/hosts \
  -v /opt/coredns/coredns/Corefile:/Corefile \
  192.168.80.54:8081/coredns/coredns:1.6.0
```

```
.:53 {
    etcd {
        stubzones
        path /skydns
        endpoint http://192.168.81.114:2379 
        upstream 172.17.0.13:53 /etc/resolv.conf
        fallthrough
    }
    cache 160
    reload 6s
    loadbalance
    forward . 172.17.0.13:53 /etc/resolv.conf
    log
    errors
}
```

```
etcdctl put /skydns/tech/rdev/heheda '{"host":"1.1.1.1","ttl":10}'
```

```
192.168.80.54:8081/library/deltaprojects/etcdkeeper
```

```
docker run  -d \
--name etcdkeeper \
-p 8080:8080 \
192.168.80.54:8081/library/deltaprojects/etcdkeeper
192.168.80.54:8081/library/teapot/external-dns:0.7.5
```

```
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: external-dns
rules:
- apiGroups: [""]
  resources: ["services","endpoints","pods"]
  verbs: ["get","watch","list"]
- apiGroups: ["extensions","networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get","watch","list"]
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["list"]
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: external-dns-viewer
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: external-dns
subjects:
- kind: ServiceAccount
  name: external-dns
  namespace: kube-system
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: external-dns
  namespace: kube-system
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: external-dns
  namespace: kube-system
spec:
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: external-dns
  template:
    metadata:
      labels:
        app: external-dns
    spec:
      serviceAccountName: external-dns
      containers:
      - name: external-dns
        image: 192.168.80.54:8081/library/teapot/external-dns:0.7.5
        args:
        - --source=ingress
        - --provider=coredns
        - --log-level=debug # debug only
        - --publish-host-ip
        env:
        - name: ETCD_URLS
          value: http://192.168.81.114:2379
```

