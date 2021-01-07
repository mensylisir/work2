### 安装cfssl



---

scp -P7122 root@192.168.80.89:/opt/package/cfssl/* /usr/local/bin/

chmod +x /usr/local/bin/cfssl /usr/local/bin/cfssljson /usr/local/bin/cfssl-certinfo

---



## 生成cert



---



mkdir -p /opt/cert

cd /opt/cert

scp -P7122 root@192.168.80.89:/opt/package/cert/* /opt/cert/

修改 harbor-csr.json内容和名字

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=www harbor-csr.json | cfssljson -bare harbor-dev     # harbor-csr.json和harbor-dev修改成需要生成的证书

---

