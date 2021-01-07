1. download

   ```
   wget https://download.docker.com/linux/static/stable/x86_64/docker-19.03.9.tgz
   ```

   ```
   curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   ```

2. unpack

   ```
   tar -zxvf docker-19.03.9.tgz
   ```

3. move to /usr/local/bin

   ```
   cp docker/* /usr/local/bin
   ```

   ```
   cp docker-compose /usr/local/bin
   ```

4. create docker.service

   ```shell
   # vim /usr/lib/systemd/system/docker.service
   [Unit]
   Description=Docker Application Container Engine
   Documentation=https://docs.docker.com
   After=network-online.target firewalld.service
   Wants=network-online.target
   
   [Service]
   Type=notify
   ExecStart=/usr/local/bin/dockerd
   ExecReload=/bin/kill -s HUP $MAINPID
   LimitNOFILE=infinity
   LimitNPROC=infinity
   LimitCORE=infinity
   TimeoutStartSec=0
   Delegate=yes
   KillMode=process
   Restart=on-failure
   StartLimitBurst=3
   StartLimitInterval=60s
   
   [Install]
   WantedBy=multi-user.target
   ```

   