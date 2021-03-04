FROM 192.168.80.54:8081/library/jenkins/jnlp-slave:latest
ENV GO_VERSION 1.15.5
USER root
RUN wget -O go.tgz "https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz" \
	&& tar -xzvf go.tgz -C /usr/share \
	&& export PATH="/usr/local/go/bin:$PATH"
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
EXPOSE 8080
WORKDIR $GOPATH