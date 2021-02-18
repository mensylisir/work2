
rm -f /var/run/yum.pid
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root reset.yml  --flush-cache -vvv
 
 setenforce 0
 sed -i --follow-symlinks 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux 
 createrepo -v /var/ftp/pub/localrepo/
 systemctl restart vsftpd
 yum --disablerepo=* --enablerepo=localrepo clean expire-cache
 ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml  --flush-cache --tags=yum-local -vvv
 ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml  --flush-cache --tags=upload-images -vvv
 ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml  --flush-cache -vvv

 yum install docker-ce-19.03.14-3.el7  containerd.io-1.3.9-3.1.el7 docker-ce-cli-19.03.14-3.el7 container-selinux-2.119.2-1.911c772.el7_8.noarch -y

 systemctl start firewalld

 firewall-cmd --permanent --add-port=6443/tcp
 firewall-cmd --permanent --add-port=2379-2380/tcp
 firewall-cmd --permanent --add-port=10240-10255/tcp
 firewall-cmd --permanent --add-port=10250/tcp
 firewall-cmd --permanent --add-port=10255/tcp

 firewall-cmd --permanent --add-port=30000-32767/tcp
 firewall-cmd --permanent --add-port=6783/tcp
 firewall-cmd --reload
 firewall-cmd --list-ports

 systemctl stop firewalld && systemctl disable firewalld

 repotrack -p /root/rpm openssl curl rsync socat unzip e2fsprogs xfsprogs ebtables ipvsadm ipset



 1. etcd_kubeadm_enabled=false
 	put cert and key in 
 	/etc/ssl/etcd/ca.pem
 	/etc/ssl/etcd/ca-key.pem
 2. etcd_kubeadm_enabled=true
  	put cert and key in 
 	/etc/ssl/etcd/ca.crt
 	/etc/ssl/etcd/ca.key
 3. k8s cert and key should be put in 
 	/etc/kubernetes/ssl/ca.crt
 	/etc/kubernetes/ssl/ca.key

 	pem转crt
 	openssl x509  -in your-cert.pem -out your-cert.crt
 	scp root@192.168.71.68:/opt/{ca.crt,ca.key,ca.pem,ca-key.pem} .

	 检查etcd 健康
	ETCDCTL_API=3 /usr/local/bin/etcdctl --endpoints=https://192.168.80.60:2379,https://192.168.80.61:2379,https://192.168.81.116:2379 --cert=/etc/ssl/etcd/ssl/node-node1.pem --key=/etc/ssl/etcd/ssl/node-node1-key.pem --cacert=/etc/ssl/etcd/ssl/ca.pem --write-out table endpoint health

	查看一致性和谁是leader
	ETCDCTL_API=3 /usr/local/bin/etcdctl --endpoints=https://192.168.80.60:2379,https://192.168.80.61:2379,https://192.168.81.116:2379 --cert=/etc/ssl/etcd/ssl/node-node1.pem --key=/etc/ssl/etcd/ssl/node-node1-key.pem --cacert=/etc/ssl/etcd/ssl/ca.pem --write-out table endpoint status

	列出成员
	ETCDCTL_API=3 /usr/local/bin/etcdctl --endpoints=https://192.168.80.60:2379 --cert=/etc/ssl/etcd/ssl/node-node1.pem --key=/etc/ssl/etcd/ssl/node-node1-key.pem --cacert=/etc/ssl/etcd/ssl/ca.pem --write-out table member list


	# 
	kubectl get cs

	scheduler            Unhealthy   Get "http://127.0.0.1:10251/healthz": dial tcp 127.0.0.1:10251: connect: connection refused   
	controller-manager   Unhealthy   Get "http://127.0.0.1:10252/healthz": dial tcp 127.0.0.1:10252: connect: connection refused   
	etcd-2               Healthy     {"health":"true"}                                                                             
	etcd-1               Healthy     {"health":"true"}                                                                             
	etcd-0               Healthy     {"health":"true"}

	anwser: 注释掉port=0
	vim /etc/kubernetes/manifests/kube-controller-manager.yaml
	vim /etc/kubernetes/manifests/kube-scheduler.yaml