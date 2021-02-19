1 执行mkdircert创建用户config
使用kubectl get pods -n finance-fssc --kubeconfig /root/k8s-chenpeitao.conf查看是否有权限
[root@cars-master-2 cert]# kubectl get pods -n finance-fssc --kubeconfig /root/k8s-chenpeitao.conf
Error from server (Forbidden): pods is forbidden: User "chenpeitao" cannot list resource "pods" in API group "" in the namespace "finance-fssc"
2 部署new-user.yaml，设置roles和绑定
使用kubectl get pods -n finance-fssc --kubeconfig /root/k8s-chenpeitao.conf查看是否有权限
[root@cars-master-2 cert]# kubectl get pods -n finance-fssc --kubeconfig /root/k8s-chenpeitao.conf
No resources found in finance-fssc namespace.

k8s-chenpeitao.conf 是config文件
注意点： 
1 k8s需要1.8.4以上
2 给sh脚本添加权限
3 需要在k8s-master上生成