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