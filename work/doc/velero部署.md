## velero

> 1. Download
>
>    ```
>    https://github.com/vmware-tanzu/velero/releases/download/v1.5.2/velero-v1.5.2-linux-amd64.tar.gz
>    tar zxvf velero-v1.4.0-linux-amd64.tar.gz
>    cd velero-v1.4.0-linux-amd64
>    mv velero /usr/local/bin/
>    ```

> 2. image
>
>    ```
>    192.168.80.54:8081/library/minio/mc:latest
>    ```
>
>    ```
>    192.168.80.54:8081/library/minio/minio:latest
>    192.168.80.54:8081/library/velero/velero:v1.5.2
>    192.168.80.54:8081/library/velero/velero-plugin-for-aws:v1.0.0
>    ```

> 3. 部署minio.yaml
>
> 4. 部署minio-ingress.yaml
>
>    ```
>    kubectl create secret tls minio-ingress-secret --cert=tls.crt --key=tls.key -n velero
>    kubectl get secret -n velero
>    kubectl describe secret minio-ingress-secret -n velero
>    ```
>
> 5. 创建密钥
>
>    ```
>     vim /opt/velero_install/credentials-velero
>    ```
>
>    ```
>    [default]
>    aws_access_key_id = minio
>    aws_secret_access_key = minio123
>    ```
>   ```
> 
> 6. 复制velero到/usr/local/bin
> 
>   ```
>   cp velero /usr/local/bin
>    chmod +x /usr/local/bin/velero
>   ```
> 
>   ```
>
>    ```
> 
> 7. 安装
> 
>    ```
>   velero install \
>         --provider aws \
>   	 --image 192.168.80.54:8081/library/velero/velero:v1.5.2 \
>         --plugins 192.168.80.54:8081/library/velero/velero-plugin-for-aws:v1.0.0 \
>         --bucket velero \
>    	 --use-restic \
>         --secret-file /opt/velero_install/credentials-velero \
>         --use-volume-snapshots=false \
>         --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http:/192.168.80.79:32561,publicUrl=http://192.168.80.79:32561
>
>    ```
> 
>    ```

> 8. 备份命名空间级别的数据
>
>    ```
>    velero backup create nginx-backup --include-namespaces nginx-example
>    ```
>
>    ```
>    
>    ```

```
kubectl apply -f 00-minio-deployment.yaml
```

```
velero install \
   --provider aws \
   --image 192.168.80.54:8081/library/velero/velero:v1.5.2 \
   --plugins 192.168.80.54:8081/library/velero/velero-plugin-for-aws:v1.0.0 \
   --bucket velero \
   --use-restic --wait \
   --default-volumes-to-restic \
   --secret-file /opt/velero_install/credentials-velero \
   --use-volume-snapshots=false \
   --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://192.168.80.86:9000,publicUrl=http://192.168.80.86:9000
```

```
velero restore create --from-backup nginx-backup --wait
```



```
kubectl apply -f base.yaml
```

```
velero backup create nginx-backup --include-namespaces nginx-example
```

```
velero backup create gitlab-backup --include-namespaces gitlab-dev
```

```
velero backup create jenkins-backup --include-namespaces jenkins
```

```
velero backup create argocd-backup --include-namespaces argocd
```

```
velero backup create gitlab-backup2 --include-namespaces gitlab-dev2
```



```
velero backup get
```

```
kubectl get backupstoragelocations -n velero
```

```
kubectl delete namespace/velero clusterrolebinding/velero
kubectl delete crds -l component=velero
```

