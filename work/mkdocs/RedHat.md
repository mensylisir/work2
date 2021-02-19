截止到本周五，已经完成了Hub Cluster（hub）和Managed Cluster（ocp1）两套集群的安装和配置、更换Harbor仓库、ACM集群的安装和配置工作（加入ocp1集群），以下是环境的相关信息，请参考：

  DNS：192.168.80.48（自建）

  安装机：192.168.80.48（同时为http server、DNS、Hub-LB和Hub集群的管理机）

  LB2：192.168.80.47（即ocp1-LB，同时为NFS server和ocp1集群的管理机）

以下为集群访问的入口：

Hub Cluster：

  配置DNS或修改/etc/hosts
  192.168.80.48 [api.hub.rdev.rails.cn](http://api.hub.rdev.rails.cn/)

  192.168.80.48 [console-openshift-console.apps.hub.rdev.rails.cn](http://console-openshift-console.apps.hub.rdev.rails.cn/)
  192.168.80.48 [oauth-openshift.apps.hub.rdev.rails.cn](http://oauth-openshift.apps.hub.rdev.rails.cn/)



  oc命令访问：

  oc login -u user1 [https://api.hub.rdev.rails.cn:6443](https://api.hub.rdev.rails.cn:6443/)

  Web Console访问：
  https://console-openshift-console.apps.hub.rdev.rails.cn/
  ACM Web Console:

  https://multicloud-console.apps.hub.rdev.rails.cn/

Managed Cluster
  配置DNS或修改/etc/hosts

  192.168.80.47 [api.ocp1.rdev.rails.cn](http://api.ocp1.rdev.rails.cn/)
  192.168.80.47 [console-openshift-console.apps.ocp1.rdev.rails.cn](http://console-openshift-console.apps.ocp1.rdev.rails.cn/)
  192.168.80.47 [oauth-openshift.apps.ocp1.rdev.rails.cn](http://oauth-openshift.apps.ocp1.rdev.rails.cn/)

  oc命令访问：

  oc login -u user1 [https://api.ocp1.rdev.rails.cn:6443](https://api.ocp1.rdev.rails.cn:6443/) 

  Web Console访问：

 https://console-openshift-console.apps.ocp1.rdev.rails.cn/

