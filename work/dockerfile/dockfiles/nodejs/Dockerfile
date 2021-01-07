FROM jenkins/agent:alpine
ENV NODE_VERSION 14.15.0
USER root
RUN sed -i s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g /etc/apk/repositories
RUN set -eux; \ 
	apk update && \
    apk add --no-cache curl gcc g++ make python2 wget linux-headers \
    && wget -O node-v$NODE_VERSION.tar.gz "https://npm.taobao.org/mirrors/node/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz" \
    && tar -xvf "node-v$NODE_VERSION.tar.gz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure  \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.gz" 

CMD [ "node" ]