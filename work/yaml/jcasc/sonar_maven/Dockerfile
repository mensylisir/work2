FROM 192.168.80.54:8081/library/jenkins/jnlp-slave:latest
USER root
ARG MAVEN_VERSION=3.6.3
ARG MAVEN_SHA=fae9c12b570c3ba18116a4e26ea524b29f7279c17cbaadc3326ca72927368924d9131d11b9e851b8dc9162228b6fdea955446be41207a5cfc61283dd8a561d2f
ARG MAVEN_BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
ARG SONAR_VERSION=4.5.0.2216
ARG SONAR_URL=https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.5.0.2216.zip
RUN  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo Asia/Shanghai > /etc/timezone \
  && mkdir -p /usr/share/maven /usr/share/maven/ref/repository \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
  && wget -O /tmp/sonar-scanner-cli-${SONAR_VERSION}.zip $SONAR_URL \
  && unzip /tmp/sonar-scanner-cli-${SONAR_VERSION}.zip -d /usr/share \
  && rm -f /tmp/sonar-scanner-cli-${SONAR_VERSION}.zip \
  && ln -s /usr/share/sonar-scanner-${SONAR_VERSION}/bin/sonar-scanner /usr/bin/sonar-scanner

ENV MAVEN_HOME /usr/share/maven
ENV SONAR_HOME=/usr/share/sonar-scanner-4.5.0.2216
ENV GIT_SSL_NO_VERIFY=1
VOLUME /usr/share/maven/ref/repository
COPY sonar-scanner.properties ${SONAR_HOME}/conf/sonar-scanner.properties
COPY settings.xml ${MAVEN_HOME}/conf/settings.xml