### 搭建nacos



1 下载docker-compose https://github.com/nacos-group/nacos-docker

2 修改nacos-docker-master\example\standalone-mysql-5.7.yaml 内的images

```
version: "2"
services:
  nacos:
    image: harbor.dev.rdev.tech/nacos/nacos-server:latest
    container_name: nacos-standalone-mysql
    env_file:
      - ../env/nacos-standlone-mysql.env
    volumes:
      - ./standalone-logs/:/home/nacos/logs
      - ./init.d/custom.properties:/home/nacos/init.d/custom.properties
    ports:
      - "8848:8848"
      - "9555:9555"
    depends_on:
      - mysql
    restart: on-failure
  mysql:
    container_name: mysql
    image: harbor.dev.rdev.tech/nacos/nacos-mysql:5.7
    env_file:
      - ../env/mysql.env
    volumes:
      - ./mysql:/var/lib/mysql
    ports:
      - "3306:3306"
  prometheus:
    container_name: prometheus
    image: harbor.dev.rdev.tech/prom/prometheus:latest
    volumes:
      - ./prometheus/prometheus-standalone.yaml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    depends_on:
      - nacos
    restart: on-failure
  grafana:
    container_name: grafana
    image: harbor.dev.rdev.tech/grafana/grafana:latest
    ports:
      - 3000:3000
    restart: on-failure


```

3 使用docker-compose启动 

```
docker-compose up -d
```

