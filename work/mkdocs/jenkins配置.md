jenkins 地址:  http://x.x.x.x :port 

```
CLUSTER-IP   kubectl  get svc -n xxx
```

jenkins 通道:x.x.x.x:port      

```
kubectl exec -it xxxx -n xxx   -- /bin/bash

env |grep tcp 
```





Pipeline script 

```
podTemplate(containers: [
    containerTemplate(name: 'jnlp', image: '192.168.80.54:8081/library/jenkins/agent_maven:v1.0.5_alpha', ttyEnabled: true)
  ],
  	volumes: [hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock'),
                hostPathVolume(hostPath: '/usr/local/bin/docker', mountPath: '/usr/local/bin/docker'),
                hostPathVolume(hostPath: '/usr/local/bin/kubectl', mountPath: '/usr/local/bin/kubectl')]) {

    node(POD_LABEL) {
        stage('Get a Maven project') {
            container('jnlp') {
                git  credentialsId: 'lmg_ssh', url: 'http://192.168.71.68:10080/liminggang/test123.git', branch: 'master'
                stage('Build a Maven project') {
                    echo "111111111111111"
                    sh "sed -i s/nexus.rdev.tech/192.168.81.103:8081/g /usr/share/maven/conf/settings.xml"
                    sh "sed -i s/abc123B,/Def@u1tpwd/g /usr/share/maven/conf/settings.xml"
                    sh "ls -la"
                    sh "echo 192.168.71.65 nexus.rdev.tech >> /etc/hosts"
                    sh "docker version"
                    sh "kubectl version"
                    // sh "ping nexus.rdev.tech -s 10000"
                    sh "mvn -f pom.xml clean package"
                    // sh "ping nexus.rdev.tech -s 10000"
                    sh "mvn sonar:sonar -Dsonar.host.url=http://192.168.80.79:30001 -Dsonar.login=83b9ecd042ebf64521d9fbf43124b44a8c2047a2"
                }
            }
        }
    }
}
```



 

![image-20201223083607071](jenkins%E9%85%8D%E7%BD%AE.assets/image-20201223083607071.png)









![image-20201223083705179](jenkins%E9%85%8D%E7%BD%AE.assets/image-20201223083705179.png)



 ![image-20201223083847411](jenkins%E9%85%8D%E7%BD%AE.assets/image-20201223083847411.png)



![image-20201223084024602](jenkins%E9%85%8D%E7%BD%AE.assets/image-20201223084024602.png)

![image-20201223084101018](jenkins%E9%85%8D%E7%BD%AE.assets/image-20201223084101018.png)