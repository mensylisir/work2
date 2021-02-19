



```
192.168.80.54:8081/library/sameersbn/bind:latest
```

```shell
docker run -d --name=bind --dns=172.17.0.13 --restart=always --publish=192.168.80.54:53:53/udp --publish=192.168.80.54:10000:10000 --volume=/data/bind:/data/bind --env='ROOT_PASSWORD=1qaz@WSX' -v /etc/localtime:/etc/localtime 192.168.80.54:8081/library/sameersbn/bind:latest
```

