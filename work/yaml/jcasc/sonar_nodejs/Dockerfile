FROM 192.168.80.54:8081/library/jenkins/jnlp-slave:latest
USER root
ENV NODE_VERSION 14.15.0
ARG SONAR_VERSION=4.5.0.2216
ARG SONAR_URL=https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.5.0.2216.zip
RUN wget -O node-v$NODE_VERSION-linux-x64.tar.gz "https://npm.taobao.org/mirrors/node/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& tar -xzvf node-v$NODE_VERSION-linux-x64.tar.gz -C /usr/share \
	&& ln -sf /usr/share/node-v$NODE_VERSION-linux-x64/bin/node /usr/local/bin/node \
	&& ln -sf /usr/share/node-v$NODE_VERSION-linux-x64/bin/npm /usr/local/bin/npm \
	&& wget -O /tmp/sonar-scanner-cli-${SONAR_VERSION}.zip $SONAR_URL \
	&& unzip /tmp/sonar-scanner-cli-${SONAR_VERSION}.zip -d /usr/share \
	&& rm -f /tmp/sonar-scanner-cli-${SONAR_VERSION}.zip \
	&& ln -s /usr/share/sonar-scanner-${SONAR_VERSION}/bin/sonar-scanner /usr/bin/sonar-scanner

ENV SONAR_HOME=/usr/share/sonar-scanner-4.5.0.2216
ENV GIT_SSL_NO_VERIFY=1
COPY sonar-scanner.properties ${SONAR_HOME}/conf/sonar-scanner.properties