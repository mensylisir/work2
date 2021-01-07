### pod添加域名解析

使用hostAliases添加

```
apiVersion: v1
kind: Pod
metadata:
  name: hostaliases-pod
spec:
  restartPolicy: Never
  hostAliases:
  - ip: "127.0.0.1"
    hostnames:
    - "foo.local"
    - "bar.local"
  - ip: "10.1.2.3"
    hostnames:
    - "foo.remote"
    - "bar.remote"
  containers:
  - name: cat-hosts
    image: busybox
    command:
    - cat
    args:
    - "/etc/hosts"
```



```
# Kubernetes-managed hosts file.
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
fe00::0	ip6-mcastprefix
fe00::1	ip6-allnodes
fe00::2	ip6-allrouters
10.200.0.5	hostaliases-pod

# Entries added by HostAliases.
127.0.0.1	foo.local	bar.local
10.1.2.3	foo.remote	bar.remote
```



###  docker-compose 添加解析

  在`docker-compose.yml`文件中，通过配置参数`extra_hosts`来实现。例如：

```
extra_hosts:
 - "keycloak-dev.rdev.tech:192.168.81.104"
 - "harbor-dev.rdev.tech:192.168.80.77"
```

```
192.168.81.104  keycloak-dev.rdev.tech
192.168.80.77   harbor-dev.rdev.tech
```



### docker 添加解析

 在docker启动中添加--add-host 参数来实现。例如：

```
docker run --name jenkins-blueocean -u root --add-host=git.rdev.tech:192.168.71.65 --add-host=sonarqube.rdev.tech:192.168.71.65  --add-host=nexus.rdev.tech:192.168.71.65 --detach -v /opt/jenkins/jenkins-data:/var/jenkins_home -v /opt/jenkins/blueocean:/home  -p 9999:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock harbor.rdev.tech/jenkinsci/blueocean
```

