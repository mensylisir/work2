FROM jenkins/jenkins:alpine
USER root
COPY ./hosts /etc/hosts
COPY plugins/* /var/jenkins_home/plugins/
RUN echo "https://mirrors.aliyun.com/alpine/v3.8/main/" > /etc/apk/repositories \
  && echo "https://mirrors.aliyun.com/alpine/v3.8/community/" >> /etc/apk/repositories \
  && apk add -U tzdata \
  && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && apk del tzdata