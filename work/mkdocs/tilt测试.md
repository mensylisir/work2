## 1.安装docker

## 2.准备

![image-20210104103818928](tilt%E6%B5%8B%E8%AF%95.assets/image-20210104103818928.png)

## 3.加载镜像kind-node：1.19.1.tar

```
docker load -i ./kind-node-1.19.1.tar   或者
docker pull kindest/node:v1.19.1
```

```
docker images   查看镜像是否加载成功
```

![image-20210104104110474](tilt%E6%B5%8B%E8%AF%95.assets/image-20210104104110474.png)

### 3.1docker加载新的镜像后repository和tag名称都为none的解决方法

```
docker tag [image id] [name]:[版本]
例如： docker tag 37ddbc9063d2 kind-node-1.19.1
```

![image-20210104104315992](tilt%E6%B5%8B%E8%AF%95.assets/image-20210104104315992.png)

## 4.执行kind

本地创建一个虚拟集群

```
D:\works\k8s_docs\kub\kind.exe create cluster
```

![image-20210104105301164](tilt%E6%B5%8B%E8%AF%95.assets/image-20210104105301164.png)

## 5.启动

```
kubectl cluster-info --context kind-kind
```

![image-20210104105533998](tilt%E6%B5%8B%E8%AF%95.assets/image-20210104105533998.png)

## 6.安装配置tilt

### 6.1 下载busybox镜像，用于执行main.sh时使用

```
docker pull busybox
```

### 6.2 下载tilt目录

用开发发的tilt-example-html 

### 6.3 把kub目录下的kind和tilt执行程序拷贝到tilt-example-html 目录下

![image-20210104110409840](tilt%E6%B5%8B%E8%AF%95.assets/image-20210104110409840.png)

### 6.4 运行tilt up 

```
D:\works\k8s_docs\kub\tilt-example-html\3-base-tichu\tilt.exe up
```

![image-20210104111205110](tilt%E6%B5%8B%E8%AF%95.assets/image-20210104111205110.png)

按住空格键渲染页面

![image-20210104111245157](tilt%E6%B5%8B%E8%AF%95.assets/image-20210104111245157.png)

访问本地的8000端口

![image-20210104111310625](tilt%E6%B5%8B%E8%AF%95.assets/image-20210104111310625.png)









### 7.工程渲染(例子)

![image-20210104135618598](tilt%E6%B5%8B%E8%AF%95.assets/image-20210104135618598.png)

将以上的几个文件放到0-base下

打开0-base下的Tiltfile，改成下面的内容

```
docker_build('tichu-image', '.')

k8s_yaml('kubernetes.yaml')

k8s_resource('tichu', port_forwards=8000)
```

将kubernetes.yaml文件内容修改：

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tichu
  labels:
    app: tichu
spec:
  selector:
    matchLabels:
      app: tichu
  template:
    metadata:
      labels:
        app: tichu
    spec:
      containers:
      - name: tichu
        image: tichu-image
        ports:
        - containerPort: 8000

```

用D:\works\k8s_docs\kub\tilt-example-html\0-base\tilt.exe up加载tichu的镜像

![image-20210104152327422](tilt%E6%B5%8B%E8%AF%95.assets/image-20210104152327422.png)

打开本地localhost:8000

![image-20210104152425475](tilt%E6%B5%8B%E8%AF%95.assets/image-20210104152425475.png)