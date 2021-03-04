FROM 192.168.80.54:8081/library/jenkins/jnlp-slave:latest
USER root
ENV NODE_VERSION 14.15.0
RUN wget -O node-v$NODE_VERSION-linux-x64.tar.gz "https://npm.taobao.org/mirrors/node/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& tar -xzvf node-v$NODE_VERSION-linux-x64.tar.gz -C /usr/share \
	&& ln -sf /usr/share/node-v$NODE_VERSION-linux-x64/bin/node /usr/local/bin/node \
	&& ln -sf /usr/share/node-v$NODE_VERSION-linux-x64/bin/npm /usr/local/bin/npm