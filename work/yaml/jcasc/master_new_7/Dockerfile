FROM 192.168.80.54:8081/library/jenkins/jenkins:v1.0.1_alpha
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY seedjob.groovy /var/jenkins_home/seedjob.groovy
COPY casc.yaml /var/jenkins_home/casc.yaml
ENV GIT_SSL_NO_VERIFY=1
