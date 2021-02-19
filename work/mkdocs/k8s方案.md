1. ceph
2. vSan

环境

流水线应用

注意的点



- 基于kubeoperator进行集群搭建

- 需要做mysql数据库高可用



### > 1. 组件

### > 2. 计算方案

### > 3. 存储方案

### > 4. 网络方案



1. 集群
2. 存储方案，ceph、vsan
3. 备份s3命令还是ceph()
4. ArgoCD cert-manager vault  helm chart 3.0 istio sonobuoy chaos kuectl plugin管理工具krew及相关插件、tilt
5. 



1. 一个界面监控多集群，alertmanager到什么地方
2. 日志存储、分析
3. 追踪，老 新
4. 以后Envoy
5. Octant插件调查， 其他方案，区分日志
6. cert-manager
7. argo-cd argo roll out
8. Open Policy Agent 来源  签名 
9. cluster api





1. 环境\基本开发方法(框图)

   > 1. 集群的快速搭建
   > 2. gitlab、nexus、harbor
   > 3. jenkins、sornarqube、argocd
   > 4. DNS、证书
   > 5. helm、kustomize熟练使用，tilt、telepresense（蒙元）

2. 升级、备份、cert-manager

3. 认证授权 、OPA

   > 1. k8s认证授权
   > 2. keycloak

4. 日志、网关、Istio



## 工作计划

- 升级、备份、cert-manager

- 认证授权 、OPA

- 日志、网关、Istio

  > - 追踪云至进度
  > - 审查文档
  > - 根据文档能够部署这些组件

- 集群的快速搭建 					20201207

  > + 使用kubeoperator进行集群搭建

- jenkins集群的搭建                20201207

  > - jenkins单独一个集群

- nexus repo的搭建                20201207

  > - 搭建nexus仓库
  > - 将旧的nexus仓库的包导入到新仓库

- sonarqube扫描环境             20201208

  > - sonarqube pipeline

- CoreDNS                               20201208

- harbor双机备份环境            20201208-20201209

  > - 环境搭建

  > - 双机备份

  > - HTTPS证书

- gitlab仓库搭建                      20201209-20201210

  > - 搭建
  > - 备份

- argocd                                   20201210-20201211

- 流水线测试                            20201214-20201215

  > - 跑通流程
  > - pipeline

- helm、kustomize                20201216

- 文档整理                                20201217

- 框图                                        20201218