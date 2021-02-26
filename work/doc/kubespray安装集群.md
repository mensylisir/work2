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
>    
>    
>    #或者通过ansible-playbook
>    ---
>    - hosts: all
>      gather_facts: false
>      tasks:
>      - name: deliver authorized_keys
>        authorized_key:
>            user: root
>            key: "{{ lookup('file', '/root/.ssh/id_rsa.pub') }}"  
>            state: present
>            exclusive: no
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
>    
>    
>    
>    #或者通过ansible-playbook
>    ---
>    - hosts: all
>      gather_facts: false
>      tasks:
>        - name: scp repo to host
>          copy:
>                src: '/etc/docker/daemon.json'
>                dest: '/etc/docker/daemon.json'
>                owner: root
>                group: root
>                mode: 0755
>                force: yes
>                backup: yes
>          tags:
>            - scp_json_to_host
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

> 8. Deploy ingress-controller
>
>    ```yaml
>    
>    apiVersion: v1
>    kind: Namespace
>    metadata:
>      name: ingress-nginx
>      labels:
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>    
>    ---
>    # Source: ingress-nginx/templates/controller-serviceaccount.yaml
>    apiVersion: v1
>    kind: ServiceAccount
>    metadata:
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: controller
>      name: ingress-nginx
>      namespace: ingress-nginx
>    ---
>    # Source: ingress-nginx/templates/controller-configmap.yaml
>    apiVersion: v1
>    kind: ConfigMap
>    metadata:
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: controller
>      name: ingress-nginx-controller
>      namespace: ingress-nginx
>    data:
>    ---
>    # Source: ingress-nginx/templates/clusterrole.yaml
>    apiVersion: rbac.authorization.k8s.io/v1
>    kind: ClusterRole
>    metadata:
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>      name: ingress-nginx
>    rules:
>      - apiGroups:
>          - ''
>        resources:
>          - configmaps
>          - endpoints
>          - nodes
>          - pods
>          - secrets
>        verbs:
>          - list
>          - watch
>      - apiGroups:
>          - ''
>        resources:
>          - nodes
>        verbs:
>          - get
>      - apiGroups:
>          - ''
>        resources:
>          - services
>        verbs:
>          - get
>          - list
>          - watch
>      - apiGroups:
>          - extensions
>          - networking.k8s.io   # k8s 1.14+
>        resources:
>          - ingresses
>        verbs:
>          - get
>          - list
>          - watch
>      - apiGroups:
>          - ''
>        resources:
>          - events
>        verbs:
>          - create
>          - patch
>      - apiGroups:
>          - extensions
>          - networking.k8s.io   # k8s 1.14+
>        resources:
>          - ingresses/status
>        verbs:
>          - update
>      - apiGroups:
>          - networking.k8s.io   # k8s 1.14+
>        resources:
>          - ingressclasses
>        verbs:
>          - get
>          - list
>          - watch
>    ---
>    # Source: ingress-nginx/templates/clusterrolebinding.yaml
>    apiVersion: rbac.authorization.k8s.io/v1
>    kind: ClusterRoleBinding
>    metadata:
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>      name: ingress-nginx
>    roleRef:
>      apiGroup: rbac.authorization.k8s.io
>      kind: ClusterRole
>      name: ingress-nginx
>    subjects:
>      - kind: ServiceAccount
>        name: ingress-nginx
>        namespace: ingress-nginx
>    ---
>    # Source: ingress-nginx/templates/controller-role.yaml
>    apiVersion: rbac.authorization.k8s.io/v1
>    kind: Role
>    metadata:
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: controller
>      name: ingress-nginx
>      namespace: ingress-nginx
>    rules:
>      - apiGroups:
>          - ''
>        resources:
>          - namespaces
>        verbs:
>          - get
>      - apiGroups:
>          - ''
>        resources:
>          - configmaps
>          - pods
>          - secrets
>          - endpoints
>        verbs:
>          - get
>          - list
>          - watch
>      - apiGroups:
>          - ''
>        resources:
>          - services
>        verbs:
>          - get
>          - list
>          - watch
>      - apiGroups:
>          - extensions
>          - networking.k8s.io   # k8s 1.14+
>        resources:
>          - ingresses
>        verbs:
>          - get
>          - list
>          - watch
>      - apiGroups:
>          - extensions
>          - networking.k8s.io   # k8s 1.14+
>        resources:
>          - ingresses/status
>        verbs:
>          - update
>      - apiGroups:
>          - networking.k8s.io   # k8s 1.14+
>        resources:
>          - ingressclasses
>        verbs:
>          - get
>          - list
>          - watch
>      - apiGroups:
>          - ''
>        resources:
>          - configmaps
>        resourceNames:
>          - ingress-controller-leader-nginx
>        verbs:
>          - get
>          - update
>      - apiGroups:
>          - ''
>        resources:
>          - configmaps
>        verbs:
>          - create
>      - apiGroups:
>          - ''
>        resources:
>          - events
>        verbs:
>          - create
>          - patch
>    ---
>    # Source: ingress-nginx/templates/controller-rolebinding.yaml
>    apiVersion: rbac.authorization.k8s.io/v1
>    kind: RoleBinding
>    metadata:
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: controller
>      name: ingress-nginx
>      namespace: ingress-nginx
>    roleRef:
>      apiGroup: rbac.authorization.k8s.io
>      kind: Role
>      name: ingress-nginx
>    subjects:
>      - kind: ServiceAccount
>        name: ingress-nginx
>        namespace: ingress-nginx
>    ---
>    # Source: ingress-nginx/templates/controller-service-webhook.yaml
>    apiVersion: v1
>    kind: Service
>    metadata:
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: controller
>      name: ingress-nginx-controller-admission
>      namespace: ingress-nginx
>    spec:
>      type: ClusterIP
>      ports:
>        - name: https-webhook
>          port: 443
>          targetPort: webhook
>      selector:
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/component: controller
>    ---
>    # Source: ingress-nginx/templates/controller-service.yaml
>    apiVersion: v1
>    kind: Service
>    metadata:
>      annotations:
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: controller
>      name: ingress-nginx-controller
>      namespace: ingress-nginx
>    spec:
>      type: NodePort
>      ports:
>        - name: http
>          port: 80
>          protocol: TCP
>          targetPort: http
>        - name: https
>          port: 443
>          protocol: TCP
>          targetPort: https
>      selector:
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/component: controller
>    ---
>    # Source: ingress-nginx/templates/controller-deployment.yaml
>    apiVersion: apps/v1
>    kind: Deployment
>    metadata:
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: controller
>      name: ingress-nginx-controller
>      namespace: ingress-nginx
>    spec:
>      selector:
>        matchLabels:
>          app.kubernetes.io/name: ingress-nginx
>          app.kubernetes.io/instance: ingress-nginx
>          app.kubernetes.io/component: controller
>      revisionHistoryLimit: 10
>      minReadySeconds: 0
>      template:
>        metadata:
>          labels:
>            app.kubernetes.io/name: ingress-nginx
>            app.kubernetes.io/instance: ingress-nginx
>            app.kubernetes.io/component: controller
>        spec:
>          dnsPolicy: ClusterFirst
>          containers:
>            - name: controller
>              image: harbor.dev.rdev.tech/library/ingress-nginx-contrller
>              imagePullPolicy: IfNotPresent
>              lifecycle:
>                preStop:
>                  exec:
>                    command:
>                      - /wait-shutdown
>              args:
>                - /nginx-ingress-controller
>                - --election-id=ingress-controller-leader
>                - --ingress-class=nginx
>                - --configmap=$(POD_NAMESPACE)/ingress-nginx-controller
>                - --validating-webhook=:8443
>                - --validating-webhook-certificate=/usr/local/certificates/cert
>                - --validating-webhook-key=/usr/local/certificates/key
>              securityContext:
>                capabilities:
>                  drop:
>                    - ALL
>                  add:
>                    - NET_BIND_SERVICE
>                runAsUser: 101
>                allowPrivilegeEscalation: true
>              env:
>                - name: POD_NAME
>                  valueFrom:
>                    fieldRef:
>                      fieldPath: metadata.name
>                - name: POD_NAMESPACE
>                  valueFrom:
>                    fieldRef:
>                      fieldPath: metadata.namespace
>                - name: LD_PRELOAD
>                  value: /usr/local/lib/libmimalloc.so
>              livenessProbe:
>                httpGet:
>                  path: /healthz
>                  port: 10254
>                  scheme: HTTP
>                initialDelaySeconds: 10
>                periodSeconds: 10
>                timeoutSeconds: 1
>                successThreshold: 1
>                failureThreshold: 5
>              readinessProbe:
>                httpGet:
>                  path: /healthz
>                  port: 10254
>                  scheme: HTTP
>                initialDelaySeconds: 10
>                periodSeconds: 10
>                timeoutSeconds: 1
>                successThreshold: 1
>                failureThreshold: 3
>              ports:
>                - name: http
>                  containerPort: 80
>                  protocol: TCP
>                - name: https
>                  containerPort: 443
>                  protocol: TCP
>                - name: webhook
>                  containerPort: 8443
>                  protocol: TCP
>              volumeMounts:
>                - name: webhook-cert
>                  mountPath: /usr/local/certificates/
>                  readOnly: true
>              resources:
>                requests:
>                  cpu: 100m
>                  memory: 90Mi
>          nodeSelector:
>            kubernetes.io/os: linux
>          serviceAccountName: ingress-nginx
>          terminationGracePeriodSeconds: 300
>          volumes:
>            - name: webhook-cert
>              secret:
>                secretName: ingress-nginx-admission
>    ---
>    # Source: ingress-nginx/templates/admission-webhooks/validating-webhook.yaml
>    # before changing this value, check the required kubernetes version
>    # https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#prerequisites
>    apiVersion: admissionregistration.k8s.io/v1
>    kind: ValidatingWebhookConfiguration
>    metadata:
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: admission-webhook
>      name: ingress-nginx-admission
>    webhooks:
>      - name: validate.nginx.ingress.kubernetes.io
>        matchPolicy: Equivalent
>        rules:
>          - apiGroups:
>              - networking.k8s.io
>            apiVersions:
>              - v1beta1
>            operations:
>              - CREATE
>              - UPDATE
>            resources:
>              - ingresses
>        failurePolicy: Fail
>        sideEffects: None
>        admissionReviewVersions:
>          - v1
>          - v1beta1
>        clientConfig:
>          service:
>            namespace: ingress-nginx
>            name: ingress-nginx-controller-admission
>            path: /networking/v1beta1/ingresses
>    ---
>    # Source: ingress-nginx/templates/admission-webhooks/job-patch/serviceaccount.yaml
>    apiVersion: v1
>    kind: ServiceAccount
>    metadata:
>      name: ingress-nginx-admission
>      annotations:
>        helm.sh/hook: pre-install,pre-upgrade,post-install,post-upgrade
>        helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: admission-webhook
>      namespace: ingress-nginx
>    ---
>    # Source: ingress-nginx/templates/admission-webhooks/job-patch/clusterrole.yaml
>    apiVersion: rbac.authorization.k8s.io/v1
>    kind: ClusterRole
>    metadata:
>      name: ingress-nginx-admission
>      annotations:
>        helm.sh/hook: pre-install,pre-upgrade,post-install,post-upgrade
>        helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: admission-webhook
>    rules:
>      - apiGroups:
>          - admissionregistration.k8s.io
>        resources:
>          - validatingwebhookconfigurations
>        verbs:
>          - get
>          - update
>    ---
>    # Source: ingress-nginx/templates/admission-webhooks/job-patch/clusterrolebinding.yaml
>    apiVersion: rbac.authorization.k8s.io/v1
>    kind: ClusterRoleBinding
>    metadata:
>      name: ingress-nginx-admission
>      annotations:
>        helm.sh/hook: pre-install,pre-upgrade,post-install,post-upgrade
>        helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: admission-webhook
>    roleRef:
>      apiGroup: rbac.authorization.k8s.io
>      kind: ClusterRole
>      name: ingress-nginx-admission
>    subjects:
>      - kind: ServiceAccount
>        name: ingress-nginx-admission
>        namespace: ingress-nginx
>    ---
>    # Source: ingress-nginx/templates/admission-webhooks/job-patch/role.yaml
>    apiVersion: rbac.authorization.k8s.io/v1
>    kind: Role
>    metadata:
>      name: ingress-nginx-admission
>      annotations:
>        helm.sh/hook: pre-install,pre-upgrade,post-install,post-upgrade
>        helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: admission-webhook
>      namespace: ingress-nginx
>    rules:
>      - apiGroups:
>          - ''
>        resources:
>          - secrets
>        verbs:
>          - get
>          - create
>    ---
>    # Source: ingress-nginx/templates/admission-webhooks/job-patch/rolebinding.yaml
>    apiVersion: rbac.authorization.k8s.io/v1
>    kind: RoleBinding
>    metadata:
>      name: ingress-nginx-admission
>      annotations:
>        helm.sh/hook: pre-install,pre-upgrade,post-install,post-upgrade
>        helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: admission-webhook
>      namespace: ingress-nginx
>    roleRef:
>      apiGroup: rbac.authorization.k8s.io
>      kind: Role
>      name: ingress-nginx-admission
>    subjects:
>      - kind: ServiceAccount
>        name: ingress-nginx-admission
>        namespace: ingress-nginx
>    ---
>    # Source: ingress-nginx/templates/admission-webhooks/job-patch/job-createSecret.yaml
>    apiVersion: batch/v1
>    kind: Job
>    metadata:
>      name: ingress-nginx-admission-create
>      annotations:
>        helm.sh/hook: pre-install,pre-upgrade
>        helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: admission-webhook
>      namespace: ingress-nginx
>    spec:
>      template:
>        metadata:
>          name: ingress-nginx-admission-create
>          labels:
>            helm.sh/chart: ingress-nginx-3.23.0
>            app.kubernetes.io/name: ingress-nginx
>            app.kubernetes.io/instance: ingress-nginx
>            app.kubernetes.io/version: 0.44.0
>            app.kubernetes.io/managed-by: Helm
>            app.kubernetes.io/component: admission-webhook
>        spec:
>          containers:
>            - name: create
>              image: harbor.dev.rdev.tech/library/kube-webhook-certgen:v1.5.1
>              imagePullPolicy: IfNotPresent
>              args:
>                - create
>                - --host=ingress-nginx-controller-admission,ingress-nginx-controller-admission.$(POD_NAMESPACE).svc
>                - --namespace=$(POD_NAMESPACE)
>                - --secret-name=ingress-nginx-admission
>              env:
>                - name: POD_NAMESPACE
>                  valueFrom:
>                    fieldRef:
>                      fieldPath: metadata.namespace
>          restartPolicy: OnFailure
>          serviceAccountName: ingress-nginx-admission
>          securityContext:
>            runAsNonRoot: true
>            runAsUser: 2000
>    ---
>    # Source: ingress-nginx/templates/admission-webhooks/job-patch/job-patchWebhook.yaml
>    apiVersion: batch/v1
>    kind: Job
>    metadata:
>      name: ingress-nginx-admission-patch
>      annotations:
>        helm.sh/hook: post-install,post-upgrade
>        helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
>      labels:
>        helm.sh/chart: ingress-nginx-3.23.0
>        app.kubernetes.io/name: ingress-nginx
>        app.kubernetes.io/instance: ingress-nginx
>        app.kubernetes.io/version: 0.44.0
>        app.kubernetes.io/managed-by: Helm
>        app.kubernetes.io/component: admission-webhook
>      namespace: ingress-nginx
>    spec:
>      template:
>        metadata:
>          name: ingress-nginx-admission-patch
>          labels:
>            helm.sh/chart: ingress-nginx-3.23.0
>            app.kubernetes.io/name: ingress-nginx
>            app.kubernetes.io/instance: ingress-nginx
>            app.kubernetes.io/version: 0.44.0
>            app.kubernetes.io/managed-by: Helm
>            app.kubernetes.io/component: admission-webhook
>        spec:
>          containers:
>            - name: patch
>              image: harbor.dev.rdev.tech/library/kube-webhook-certgen:v1.5.1
>              imagePullPolicy: IfNotPresent
>              args:
>                - patch
>                - --webhook-name=ingress-nginx-admission
>                - --namespace=$(POD_NAMESPACE)
>                - --patch-mutating=false
>                - --secret-name=ingress-nginx-admission
>                - --patch-failure-policy=Fail
>              env:
>                - name: POD_NAMESPACE
>                  valueFrom:
>                    fieldRef:
>                      fieldPath: metadata.namespace
>          restartPolicy: OnFailure
>          serviceAccountName: ingress-nginx-admission
>          securityContext:
>            runAsNonRoot: true
>            runAsUser: 2000
>    
>    ```
>
>    ```shell
>    kubectl apply -f deploy.yaml
>    ```

> 9. Check if the ingress controller pods have started
>
>    ```shell
>    kubectl get pods -n ingress-nginx \
>      -l app.kubernetes.io/name=ingress-nginx --watch
>    ```

> 10. Check the version of the ingress controller
>
>     ```shell
>     POD_NAMESPACE=ingress-nginx
>     POD_NAME=$(kubectl get pods -n $POD_NAMESPACE -l app.kubernetes.io/name=ingress-nginx --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}')
>     
>     kubectl exec -it $POD_NAME -n $POD_NAMESPACE -- /nginx-ingress-controller --version
>     ```

> 11. Via the host network
>
>     ```
>     template:
>       spec:
>         hostNetwork: true
>     ```

> 12.  Install haproxy
>
>     ```
>     # install_haproxy.sh
>     for node_ip in 192.168.80.60 192.168.80.61
>       do
>         echo ">>> ${node_ip}"
>         ssh -p7122 root@${node_ip} "yum install -y keepalived haproxy"
>       done
>     ```

> 13. Configure haproxy
>
>     ```
>     cat > /etc/haproxy/haproxy.cfg <<EOF
>     global
>         log /dev/log    local0
>         log /dev/log    local1 notice
>         chroot /var/lib/haproxy
>         stats socket /var/run/haproxy-admin.sock mode 660 level admin
>         stats timeout 30s
>         user haproxy
>         group haproxy
>         daemon
>         nbproc 1
>     
>     defaults
>         log     global
>         timeout connect 5000
>         timeout client  10m
>         timeout server  10m
>     
>     listen  admin_stats
>         bind 0.0.0.0:10080
>         mode http
>         log 127.0.0.1 local0 err
>         stats refresh 30s
>         stats uri /status
>         stats realm welcome login\ Haproxy
>         stats auth admin:123456
>         stats hide-version
>         stats admin if TRUE
>     
>     listen kube-master
>         bind 0.0.0.0:10443
>         mode tcp
>         option tcplog
>         balance source
>         server 192.168.80.60 192.168.80.60:6443 check inter 2000 fall 2 rise 2 weight 1
>         server 192.168.80.61 192.168.80.61:6443 check inter 2000 fall 2 rise 2 weight 1
>     EOF
>     ```

> 14. distribute haproxy.cfg to other master
>
>     ```
>     # distribute_haproxy_cfg.sh
>     for node_ip in 192.168.80.60 192.168.80.61
>       do
>         echo ">>> ${node_ip}"
>         scp -P 7122 /etc/haproxy/haproxy.cfg root@${node_ip}:/etc/haproxy
>       done
>     ```

> 15. start haproxy
>
>     ```
>     # start_haproxy.sh
>     for node_ip in 192.168.80.60 192.168.80.61
>       do
>         echo ">>> ${node_ip}"
>         ssh -p7122 root@${node_ip} "systemctl enable haproxy && systemctl restart haproxy"
>       done
>     ```

> 16. check haproxy status
>
>     ```
>     # check_haproxy_status.sh
>     for node_ip in 192.168.80.60 192.168.80.61
>       do
>         echo ">>> ${node_ip}"
>         ssh -p7122 root@${node_ip} "systemctl status haproxy|grep Active"
>       done
>     ```

> 17. Check 10443 port
>
>     ```
>     # check_port_status.sh
>     for node_ip in 192.168.80.60 192.168.80.61
>       do
>         echo ">>> ${node_ip}"
>         ssh -p7122 root@${node_ip} "netstat -lnpt|grep haproxy"
>       done
>     ```

> 18. Configure master keepalived
>
>     ```
>     cat  > /etc/keepalived/keepalived-master.conf <<EOF
>     global_defs {
>         router_id lb-master-60
>     }
>     
>     vrrp_script check-haproxy {
>         script "killall -0 haproxy"
>         interval 5
>         weight -30
>     }
>     
>     vrrp_instance VI-kube-master {
>         state MASTER
>         priority 120
>         dont_track_primary
>         interface ens160
>         virtual_router_id 68
>         advert_int 3
>         track_script {
>             check-haproxy
>         }
>         virtual_ipaddress {
>             192.168.81.11
>         }
>     }
>     EOF
>     ```

> 19. Configure backup keepalived
>
>     ```
>     cat  > /etc/keepalived/keepalived-backup.conf <<EOF
>     global_defs {
>         router_id lb-backup-61
>     }
>     
>     vrrp_script check-haproxy {
>         script "killall -0 haproxy"
>         interval 5
>         weight -30
>     }
>     
>     vrrp_instance VI-kube-master {
>         state BACKUP
>         priority 110
>         dont_track_primary
>         interface ens160
>         virtual_router_id 68
>         advert_int 3
>         track_script {
>             check-haproxy
>         }
>         virtual_ipaddress {
>             192.168.81.11
>         }
>     }
>     EOF
>     ```

> 20. start keepalived
>
>     ```
>     # start_keepalived.sh
>     for node_ip in 192.168.80.60 192.168.80.61
>       do
>         echo ">>> ${node_ip}"
>         ssh -p7122 root@${node_ip} "systemctl enable keepalived &&systemctl restart keepalived" 
>     done
>     ```

> 21. check keepalived status
>
>     ```
>     # check_keepalived_status.sh
>     for node_ip in 192.168.80.60 192.168.80.61
>       do
>         echo ">>> ${node_ip}"
>         ssh -p7122 root@${node_ip} "systemctl status keepalived|grep Active" 
>     done
>     ```

> 22. ping VIP
>
>     ```
>     # ping_vip.sh
>     VIP_IF=ens160
>     MASTER_VIP=192.168.81.11
>     for node_ip in 192.168.80.60 192.168.80.61
>       do
>         echo ">>> ${node_ip}"
>         ssh -p7122 ${node_ip} "/usr/sbin/ip addr show ${VIP_IF}"
>         ssh -p7122 ${node_ip} "ping -c 1 ${MASTER_VIP}"
>       done
>     ```
>
>     