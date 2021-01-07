### 安装

---

docker run --name jenkins --detach -v D:\devops\jenkins_master\jenkins:/var/jenkins_home -v D:\devops\jenkins_master\home:/home  -p 9999:8080 -p 50000:50000 192.168.80.54:8081/jenkins/jenkins:lts

docker run --name jenkins2 --detach -v D:\devops\jenkins_master\jenkins_bak:/var/jenkins_home -v D:\devops\jenkins_master\home_bak:/home  -p 9998:8080 -p 50001:50000 192.168.80.54:8081/jenkins/jenkins:ltsv1 



 cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 9 (stretch)"
NAME="Debian GNU/Linux"
VERSION_ID="9"
VERSION="9 (stretch)"
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
jenkins@4e53be68f65c:/$ apt



Dockerfile (D:\devops\yaml\jenkins_bak\jcasc)

FROM jenkins/jenkins:latest
USER root
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt \
&& chown -R 1000:1000 /var/jenkins_home
COPY seedjob.groovy /var/jenkins_home/seedjob.groovy
COPY casc.yaml /var/jenkins_home/casc.yaml



docker build -t 192.168.80.54:8081/library/jenkins/jenkins:v1.0.0_alpha .

docker run --name jenkins --detach -v /opt/jenkins/jenkins-data:/var/jenkins_home -v /opt/jenkins/home:/home  -p 9999:8080 -p 50000:50000 192.168.80.54:8081/jenkins/jenkins:ltsv1 

---

### jenkins_maven_agent

---

FROM 192.168.80.54:8081/library/jenkins/jnlp-slave:latest
USER root
ARG MAVEN_VERSION=3.6.3
ARG MAVEN_SHA=fae9c12b570c3ba18116a4e26ea524b29f7279c17cbaadc3326ca72927368924d9131d11b9e851b8dc9162228b6fdea955446be41207a5cfc61283dd8a561d2f
ARG MAVEN_BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
RUN  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone \
  && mkdir -p /usr/share/maven /usr/share/maven/ref/repository \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn 

ENV MAVEN_HOME /usr/share/maven
VOLUME /usr/share/maven/ref/repository
COPY settings.xml /usr/share/maven/conf/settings.xml



docker build -t 192.168.80.54:8081/library/jenkins/agent_maven:v1.0.5_alpha .



docker run -i --rm --name agent --init 192.168.80.54:8081/library/jenkins/agent_maven:v1.0.5_alpha java -jar /usr/share/jenkins/agent.jar

docker run -i --rm --name agent -v /var/run/docker.sock:/var/run/docker.sock  --init 192.168.80.54:8081/library/jenkins/agent_maven:v1.0.5_alpha  java -jar /usr/share/jenkins/agent.jar

<===[JENKINS REMOTING CAPACITY]===>rO0ABXNyABpodWRzb24ucmVtb3RpbmcuQ2FwYWJpbGl0eQAAAAAAAAABAgABSgAEbWFza3hwAAAAAAAAAf4=

```
java -jar /usr/share/jenkins/agent.jar -jnlpUrl http://10.43.178.148:50000/computer/jenkins-slave001-bj81h/jenkins-agent.jnlp -secret 6162f62141b8268ab063076476e560375c57046b2049f659f4f4a28a9553f6b6 -workDir "/home/jenkins/agent"
```

---

### jenkins_nodejs_agent

---

FROM 192.168.80.54:8081/library/jenkins/jnlp-slave:latest
USER root
ENV NODE_VERSION 14.15.0
RUN wget -O node-v$NODE_VERSION-linux-x64.tar.gz "https://npm.taobao.org/mirrors/node/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && tar -xzvf node-v$NODE_VERSION-linux-x64.tar.gz -C /usr/share \
  && ln -sf /usr/share/node-v$NODE_VERSION-linux-x64/bin/node /usr/local/bin/node \
  && ln -sf /usr/share/node-v$NODE_VERSION-linux-x64/bin/npm /usr/local/bin/npm



192.168.80.54:8081/library/jenkins/agent_nodejs:v1.0.0_alpha

---

###  jenkins_go_agent

---

FROM 192.168.80.54:8081/library/jenkins/jnlp-slave:latest
ENV GO_VERSION 1.15.5
USER root
RUN wget -O go.tgz "https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz" \
  && tar -xzvf go.tgz -C /usr/share \
  && export PATH="/usr/share/go/bin:$PATH"
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/share/go/bin:$PATH
EXPOSE 8080
EXPOSE 50000
WORKDIR $GOPATH



192.168.80.54:8081/library/jenkins/agent_golang:v1.0.0_alpha

---

