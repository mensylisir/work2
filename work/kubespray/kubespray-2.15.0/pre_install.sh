etcd_cert="/etc/ssl/etcd/ssl"
k8s_cert="/etc/kubernetes/ssl"
if [ ! -d $etcd_cert ]; then
	mkdir -p $etcd_cert
fi
if [ ! -d $k8s_cert ]; then
	mkdir -p $k8s_cert
fi

cp -rf self-signed-cert/{ca.pem,ca-key.pem} $etcd_cert
cp -rf self-signed-cert/{ca.crt,ca.key} $k8s_cert
