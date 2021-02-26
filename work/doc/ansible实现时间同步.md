> ## ansible实现时间同步
>
> 1. 安装ansible
>
>    ```
>    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
>    yum update && yum install ansible -y
>    yum install ansible
>    ansible --version
>    ```

> 2. hosts文件配置
>
>    ```
>    /etc/ansible/hosts
>
>    [cluster79]
>    192.168.80.79 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.80 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.81 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.82 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.83 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>
>    [cluster84]
>    192.168.80.84 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.85 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.86 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.87 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.88 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>
>    [cluster60]
>    192.168.80.60 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.61 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.81.116 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.81.116 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>
>    [cluster32]
>    192.168.80.32 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.33 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.34 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.41 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.42 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.43 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.44 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.45 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.46 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    192.168.80.47 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>
>    192.168.81.104 ansible_ssh_port=7122 ansible_ssh_user=root ansible_ssh_pass="Def@u1tpwd"
>    ```
>
>    ```
>  /etc/ansible/ansible.cfg
>    将注释去掉：
>    host_key_checking = False
>    ```

> 3. 设置密钥认证
>
>    ```
>    authorized_key.yml配置文件：
>
>    - hosts: all
>      gather_facts: false
>      tasks:
>      - name: deliver authorized_keys
>        authorized_key:
>            user: root
>            key: "{{ lookup('file', '/root/.ssh/id_rsa.pub') }}"
>            state: present
>            exclusive: no
>    
>    ```

> 4. 时间同步
>
>    ```shell
>    ---
>    - hosts: all
>      any_errors_fatal: "{{ any_errors_fatal | default(true) }}"
>      tasks:
>        - name: Ansible Find File Glob
>          find:
>            paths: /etc/yum.repos.d
>            patterns: "*.repo"
>            hidden: yes
>          register: files_to_find
>
>        - name: Ansible Absent File Glob
>          file:
>            path: "{{ item.path }}"
>            state: absent
>          with_items: "{{ files_to_find.files }}"
>        - name: scp repo to host
>          copy:
>                src: '/etc/yum.repos.d/CentOS-Base-ip192.repo'
>                dest: '/etc/yum.repos.d'
>                owner: root
>                group: root
>                mode: 0755
>                force: yes
>             backup: yes
>          tags:
>            - scp_repo_to_host
>        - name: yum install ntp
>          yum:
>            name: ntp
>            state: installed
>          tags:
>            - install_ntp
>        - name: manual sync time with ntpdate
>          shell: /usr/sbin/ntpdate 192.168.60.8
>          tags:
>            - manual_sync_datetime
>
>    ```
>
> 5、ansible实现时间同步
>
> ```
> ansible-playbook   authorized_key.yml
> ansible-playbook   ntpdate.yml
> 
> ```
>
> ![image-20210224101948417](C:\Users\lin'xiao'qing\AppData\Roaming\Typora\typora-user-images\image-20210224101948417.png)
>
>
> ---
