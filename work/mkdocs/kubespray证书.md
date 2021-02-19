# etcd证书

```
roles\etcd\templates
```

![image-20210218090330048](kubespray%E8%AF%81%E4%B9%A6.assets/image-20210218090330048.png)

```
 1. etcd_kubeadm_enabled=false
 	put cert and key in 
 	/etc/ssl/etcd/ca.pem
 	/etc/ssl/etcd/ca-key.pem
 2. etcd_kubeadm_enabled=true
  	put cert and key in 
 	/etc/ssl/etcd/ca.crt
 	/etc/ssl/etcd/ca.key
```



# k8s证书

```
 3. k8s cert and key should be put in 
 	/etc/kubernetes/ssl/ca.crt
 	/etc/kubernetes/ssl/ca.key
```



# kubebench

1. Ensure that the --cert-file and --key-file arguments are set as appropriate (Automated)

   hen, edit the etcd pod specification file /etc/kubernetes/manifests/etcd.yaml
   on the master node and set the below parameters.
   --cert-file=</path/to/ca-file>
   --key-file=</path/to/key-file>

   ![image-20210218103103851](kubespray%E8%AF%81%E4%B9%A6.assets/image-20210218103103851.png)

2. Ensure that the --client-cert-auth argument is set to true (Automated)

   2.2 Edit the etcd pod specification file /etc/kubernetes/manifests/etcd.yaml on the master
   node and set the below parameter.
   --client-cert-auth="true"

   ![image-20210218103158525](kubespray%E8%AF%81%E4%B9%A6.assets/image-20210218103158525.png)

3. Ensure that the --peer-cert-file and --peer-key-file arguments are set as appropriate (Automated)

   2.4 Follow the etcd service documentation and configure peer TLS encryption as appropriate
   for your etcd cluster.
   Then, edit the etcd pod specification file /etc/kubernetes/manifests/etcd.yaml on the
   master node and set the below parameters.
   --peer-client-file=</path/to/peer-cert-file>
   --peer-key-file=</path/to/peer-key-file>

   ![image-20210218103343711](kubespray%E8%AF%81%E4%B9%A6.assets/image-20210218103343711.png)

4. Ensure that the --peer-client-cert-auth argument is set to true (Automated)

   2.5 Edit the etcd pod specification file /etc/kubernetes/manifests/etcd.yaml on the master
   node and set the below parameter.
   --peer-client-cert-auth=true

   ![image-20210218103416186](kubespray%E8%AF%81%E4%B9%A6.assets/image-20210218103416186.png)

5. Ensure that the --protect-kernel-defaults argument is set to true (Automated)

   4.2.6 If using a Kubelet config file, edit the file to set protectKernelDefaults: true.
   If using command line arguments, edit the kubelet service file
   /etc/systemd/system/kubelet.service on each worker node and
   set the below parameter in KUBELET_SYSTEM_PODS_ARGS variable.
   --protect-kernel-defaults=true
   Based on your system, restart the kubelet service. For example:
   systemctl daemon-reload
   systemctl restart kubelet.service

   ```
   # /etc/kubernetes/kubelet.env
   KUBELET_SYSTEM_PODS_ARGS="--protect-kernel-defaults=true"
   ```

   ![image-20210218103626577](kubespray%E8%AF%81%E4%B9%A6.assets/image-20210218103626577.png)

   ```
   # cat /etc/systemd/system/kubelet.service
   $KUBELET_CLOUDPROVIDER \
   $KUBELET_SYSTEM_PODS_ARGS
   ```

   ![image-20210218103747444](kubespray%E8%AF%81%E4%B9%A6.assets/image-20210218103747444.png)