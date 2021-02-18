1. Install

```
curl curl -sLo kubectl-crossplane https://releases.crossplane.io/stable/current/bin/linux_amd64/crank
mv kubectl-crossplane /usr/local/bin
chmod +x /usr/local/bin/kubectl-crossplane
```

2. image

```
192.168.80.54:8081/library/crossplane/provider-aws:v0.16.0
192.168.80.54:8081/library/crossplane/crossplane:v1.0.0
192.168.80.54:8081/library/oamdev/core-resource-controller:v0.5
192.168.80.54:8081/library/crossplane/oam-kubernetes-runtime:v0.2.2
192.168.80.54:8081/library/wordpress:php7.2
192.168.80.54:8081/library/wordpress:4.6.1-apache
192.168.80.54:8081/library/crossplane/oam-kubernetes-runtime:v0.2.2
```

3. Install provider
```
kubectl crossplane install provider 192.168.80.54:8081/library/crossplane/provider-aws:v0.16.0
```