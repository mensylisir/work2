FROM 192.168.80.54:8081/library/jenkins/jnlp-slave:latest
ENV GO_VERSION 1.15.5
ARG SONAR_VERSION=4.5.0.2216
ARG SONAR_URL=https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.5.0.2216.zip
USER root
RUN wget -O go.tgz "https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz" \
	&& tar -xzvf go.tgz -C /usr/share \
	&& export PATH="/usr/local/go/bin:$PATH" \
	&& wget -O /tmp/sonar-scanner-cli-${SONAR_VERSION}.zip $SONAR_URL \
	&& unzip /tmp/sonar-scanner-cli-${SONAR_VERSION}.zip -d /usr/share \
	&& rm -f /tmp/sonar-scanner-cli-${SONAR_VERSION}.zip \
	&& ln -s /usr/share/sonar-scanner-${SONAR_VERSION}/bin/sonar-scanner /usr/bin/sonar-scanner
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV SONAR_HOME=/usr/share/sonar-scanner-4.5.0.2216
ENV GIT_SSL_NO_VERIFY=1
COPY sonar-scanner.properties ${SONAR_HOME}/conf/sonar-scanner.properties
EXPOSE 8080
WORKDIR $GOPATH