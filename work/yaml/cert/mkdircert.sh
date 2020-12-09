#!/bin/bash
# 在当前目录下添加目录，用来存放证书
mkdir certs
# 设置一些变量
KUBE_URL=https://192.168.80.90:8443
CLUSTER=kubernetes
CRT_DAYS=365
USER_NAME=chenpeitao
# CA 证书可以在 master node 上找到
# 一般就在 /etc/kubernetes/ssl 或者 /etc/kubernetes/pki 里面
CA_CRT_PATH=/etc/kubernetes/pki/ca.crt
CA_KEY_PATH=/etc/kubernetes/pki/ca.key
# 生成私有密钥
openssl genrsa -out certs/$USER_NAME.key 2048
# 用私钥生成证书，CN 表示用户名，O 表示用户组
openssl req -new -key certs/$USER_NAME.key -out certs/$USER_NAME.csr \
-subj "/CN=$USER_NAME/O=finance-fssc"
# 然后用 CA 证书来给刚才生成的证书来签名
# 在这个例子中，我们给 chenpeitao 这个账户签发了一张有效期为一年的证书
openssl x509 -req -in certs/$USER_NAME.csr -CA $CA_CRT_PATH -CAkey $CA_KEY_PATH \
-CAcreateserial -out certs/$USER_NAME.crt -days $CRT_DAYS
# 存放 kubectl config 的文件
export KUBECONFIG=/root/k8s-$USER_NAME.conf
 
# 设置 cluster
kubectl config set-cluster $CLUSTER --server="$KUBE_URL" \
--certificate-authority="$CA_CRT_PATH" --embed-certs=true
 
# 设置私钥以及已签名证书
kubectl config set-credentials $USER_NAME --client-certificate=certs/$USER_NAME.crt \
--client-key=certs/$USER_NAME.key --embed-certs=true
 
# 设置 context
kubectl config set-context $USER_NAME-context --cluster=$CLUSTER --user=$USER_NAME
kubectl config use-context $USER_NAME-context