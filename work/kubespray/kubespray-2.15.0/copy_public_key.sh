 # copy_public_key.sh
 #!/bin/bash
echo "===========genrsa===================="
expect <<EOF
spawn ssh-keygen -t rsa
expect {
"*id_rsa):" {
send "\n";
exp_continue
}
"*(y/n)?" {
send "y\n"
exp_continue
}
"*passphrase):" {
send "\n"
exp_continue
}
"*again:" {
send "\n"
}
}
expect eof
EOF

echo "===========copy public key==================="
IPS=(192.168.80.32 192.168.80.33 192.168.80.34 192.168.80.41 192.168.80.42 192.168.80.43 192.168.80.44 192.168.80.45 192.168.80.46 192.168.80.47)
for ip in ${IPS[@]}
  do
    expect <<-EOF
    set timeout 5
    spawn ssh-copy-id -i -p 7122 root@$ip
    expect {
    "yes/no" { send "yes\n";exp_continue }
    "password:" { send "Def@u1tpwd\n" }
    }
  interact
  expect eof
EOF
done