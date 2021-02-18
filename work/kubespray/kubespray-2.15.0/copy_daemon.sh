echo "===========copy daemon.json==================="
IPS=(192.168.80.32 192.168.80.33 192.168.80.34 192.168.80.41 192.168.80.42 192.168.80.43 192.168.80.44 192.168.80.45 192.168.80.46 192.168.80.47)
for ip in ${IPS[@]}
  do
    expect <<-EOF
    set timeout 5
    spawn scp -P 7122 daemon.json root@$ip:/etc/docker/daemon.json
    expect {
    "yes/no" { send "yes\n";exp_continue }
    "password:" { send "Def@u1tpwd\n" }
    }
  interact
  expect eof
EOF
done