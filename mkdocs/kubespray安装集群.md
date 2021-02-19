> ## 整个流程需要4-4.5h
>
> 1. Install python3
>
>    ```
>    yum install -y python-pip python36 python-setuptools python-libs expect
>    ```

> 2. Install pip offline packages
>
>    ```
>    pip3 install --no-index --find-links="/root/pip-packages" -r requirements.txt
>    ```

> 3. Declare hosts and generate hosts.yaml
>
>    ```
>    declare -a IPS=(192.168.80.32 192.168.80.33 192.168.80.34 192.168.80.41 192.168.80.42 192.168.80.43 192.168.80.44 192.168.80.45 192.168.80.46 192.168.80.47)
>    
>    CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
>    ```

> 4. Copy public_key to authorized_key
>
>    ```shell
>     # copy_public_key.sh
>     #!/bin/bash
>    echo "===========genrsa===================="
>    expect <<EOF
>    spawn ssh-keygen -t rsa
>    expect {
>    "*id_rsa):" {
>    send "\n";
>    exp_continue
>    }
>    "*(y/n)?" {
>    send "y\n"
>    exp_continue
>    }
>    "*passphrase):" {
>    send "\n"
>    exp_continue
>    }
>    "*again:" {
>    send "\n"
>    }
>    }
>    expect eof
>    EOF
>    
>    echo "===========copy public key==================="
>    IPS=(192.168.80.32 192.168.80.33 192.168.80.34 192.168.80.41 192.168.80.42 192.168.80.43 192.168.80.44 192.168.80.45 192.168.80.46 192.168.80.47)
>    for ip in ${IPS[@]}
>      do
>        expect <<-EOF
>        set timeout 5
>        spawn ssh-copy-id -i -p 7122 root@$ip
>        expect {
>        "yes/no" { send "yes\n";exp_continue }
>        "password:" { send "Def@u1tpwd\n" }
>        }
>      interact
>      expect eof
>    EOF
>    done
>    ```

> 5.  Copy daemon.json
>
>    ```shell
>    echo "===========copy daemon.json==================="
>    IPS=(192.168.80.32 192.168.80.33 192.168.80.34 192.168.80.41 192.168.80.42 192.168.80.43 192.168.80.44 192.168.80.45 192.168.80.46 192.168.80.47)
>    for ip in ${IPS[@]}
>      do
>        expect <<-EOF
>        set timeout 5
>        spawn scp -P 7122 daemon.json root@$ip:/etc/docker/daemon.json
>        expect {
>        "yes/no" { send "yes\n";exp_continue }
>        "password:" { send "Def@u1tpwd\n" }
>        }
>      interact
>      expect eof
>    EOF
>    done
>    ```
>
>    
>
> 6. Install cluster
>
>    ```
>    ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml  --flush-cache -vvv
>    ```

> 7. Check result
>
>    ![image-20210219090639754](kubespray%E5%AE%89%E8%A3%85%E9%9B%86%E7%BE%A4.assets/image-20210219090639754.png)