```shell
# 创建软连接
ansible cluster32 -m file -a "src=/usr/bin/docker  dest=/usr/local/bin/docker  state=link "
```

