FROM 192.168.106.195:8081/test/java8:latest
#MAINTAINER 维护者信息
MAINTAINER dwjiang <dwjiang@ak>
ENV PORT=1389 \
    LDAPS_PORT=1636 \
    MANAGERDN='cn=directory manager' \
    APP_HOME=/apps \
    BASE_DN=dc=nrap,dc=net \
    MANAGERPASSWD=qwert12345
RUN mkdir -p $APP_HOME
#端⼝口暴暴露露
EXPOSE 4444 1389
ADD opendj.tar.gz /apps/
CMD ["/apps/opendj/bin/start-ds.sh"]
