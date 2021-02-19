```
查出该命名空间下的所有容器
kubectl get pod -n gitlab-dev2
进入到目标容器中
kubectl exec -it -n gitlab-dev2 gitlab-gitlab-ce-547b657457-szfl2 -- bash
执行备份命令即可
gitlab-rake gitlab:backup:create
```

