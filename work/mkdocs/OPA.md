### OPA

详细参见[这里](https://www.openpolicyagent.org/docs/latest/kubernetes-tutorial/)

1. 创建namespace

   ```
   kubectl create namespace opa
   ```

2. 在k8s集群部署OPA

   > 1. 生成CA证书
   >
   >    ```
   >    kubectl -n opa create secret generic opa-server --from-file=opa-key.pem --from-file=opa.pem
   >    ```
   >    
   >    ```
   >    # admission-controller.yaml
   >    # Grant OPA/kube-mgmt read-only access to resources. This lets kube-mgmt
   >    # replicate resources into OPA so they can be used in policies.
   >    kind: ClusterRoleBinding
   >    apiVersion: rbac.authorization.k8s.io/v1
   >    metadata:
   >      name: opa-viewer
   >    roleRef:
   >      kind: ClusterRole
   >      name: view
   >      apiGroup: rbac.authorization.k8s.io
   >    subjects:
   >    - kind: Group
   >      name: system:serviceaccounts:opa
   >      apiGroup: rbac.authorization.k8s.io
   >    ---
   >    # Define role for OPA/kube-mgmt to update configmaps with policy status.
   >    kind: Role
   >    apiVersion: rbac.authorization.k8s.io/v1
   >    metadata:
   >      namespace: opa
   >      name: configmap-modifier
   >    rules:
   >    - apiGroups: [""]
   >      resources: ["configmaps"]
   >      verbs: ["update", "patch"]
   >    ---
   >    # Grant OPA/kube-mgmt role defined above.
   >    kind: RoleBinding
   >    apiVersion: rbac.authorization.k8s.io/v1
   >    metadata:
   >      namespace: opa
   >      name: opa-configmap-modifier
   >    roleRef:
   >      kind: Role
   >      name: configmap-modifier
   >      apiGroup: rbac.authorization.k8s.io
   >    subjects:
   >    - kind: Group
   >      name: system:serviceaccounts:opa
   >      apiGroup: rbac.authorization.k8s.io
   >    ---
   >    kind: Service
   >    apiVersion: v1
   >    metadata:
   >      name: opa
   >      namespace: opa
   >    spec:
   >      selector:
   >        app: opa
   >      ports:
   >      - name: https
   >        protocol: TCP
   >        port: 443
   >        targetPort: 443
   >    ---
   >    apiVersion: apps/v1
   >    kind: Deployment
   >    metadata:
   >      labels:
   >        app: opa
   >      namespace: opa
   >      name: opa
   >    spec:
   >      replicas: 1
   >      selector:
   >        matchLabels:
   >          app: opa
   >      template:
   >        metadata:
   >          labels:
   >            app: opa
   >          name: opa
   >        spec:
   >          containers:
   >            # WARNING: OPA is NOT running with an authorization policy configured. This
   >            # means that clients can read and write policies in OPA. If you are
   >            # deploying OPA in an insecure environment, be sure to configure
   >            # authentication and authorization on the daemon. See the Security page for
   >            # details: https://www.openpolicyagent.org/docs/security.html.
   >            - name: opa
   >              image: 192.168.80.54:8081/library/openpolicyagent/opa:latest
   >              args:
   >                - "run"
   >                - "--server"
   >                - "--tls-cert-file=/certs/opa.pem"
   >                - "--tls-private-key-file=/certs/opa-key.pem"
   >                - "--addr=0.0.0.0:443"
   >                - "--addr=http://127.0.0.1:8181"
   >                - "--log-format=json-pretty"
   >                - "--set=decision_logs.console=true"
   >              volumeMounts:
   >                - readOnly: true
   >                  mountPath: /certs
   >                  name: opa-server
   >              readinessProbe:
   >                httpGet:
   >                  path: /health?plugins&bundle
   >                  scheme: HTTPS
   >                  port: 443
   >                initialDelaySeconds: 3
   >                periodSeconds: 5
   >              livenessProbe:
   >                httpGet:
   >                  path: /health
   >                  scheme: HTTPS
   >                  port: 443
   >                initialDelaySeconds: 3
   >                periodSeconds: 5
   >            - name: kube-mgmt
   >              image: 192.168.80.54:8081/library/openpolicyagent/kube-mgmt:0.11
   >              args:
   >                - "--replicate-cluster=v1/namespaces"
   >                - "--replicate=extensions/v1beta1/ingresses"
   >          volumes:
   >            - name: opa-server
   >              secret:
   >                secretName: opa-server
   >    ---
   >    kind: ConfigMap
   >    apiVersion: v1
   >    metadata:
   >      name: opa-default-system-main
   >      namespace: opa
   >    data:
   >      main: |
   >        package system
   >    
   >        import data.kubernetes.admission
   >    
   >        main = {
   >          "apiVersion": "admission.k8s.io/v1beta1",
   >          "kind": "AdmissionReview",
   >          "response": response,
   >        }
   >    
   >        default uid = ""
   >    
   >        uid = input.request.uid
   >    
   >        response = {
   >            "allowed": false,
   >            "uid": uid,
   >            "status": {
   >                "reason": reason,
   >            },
   >        } {
   >            reason = concat(", ", admission.deny)
   >            reason != ""
   >        }
   >        else = {"allowed": true, "uid": uid}
   >    ```
   >    
   >    ```
   >    kubectl label ns kube-system openpolicyagent.org/webhook=ignore
   >    kubectl label ns opa openpolicyagent.org/webhook=ignore
   >    ```
   >    
   >    ```
   >    
   >    ```
   >    
   >    ```
   >    cat > webhook-configuration.yaml <<EOF
   >    kind: ValidatingWebhookConfiguration
   >    apiVersion: admissionregistration.k8s.io/v1beta1
   >    metadata:
   >      name: opa-validating-webhook
   >    webhooks:
   >      - name: validating-webhook.openpolicyagent.org
   >        namespaceSelector:
   >          matchExpressions:
   >          - key: openpolicyagent.org/webhook
   >            operator: NotIn
   >            values:
   >            - ignore
   >        rules:
   >          - operations: ["CREATE", "UPDATE"]
   >            apiGroups: ["*"]
   >            apiVersions: ["*"]
   >            resources: ["*"]
   >        clientConfig:
   >          caBundle: $(cat ca.pem | base64 | tr -d '\n')
   >          service:
   >            namespace: opa
   >            name: opa
   >    EOF
   >    ```
   >    
   >    ```
   >    kubectl apply -f webhook-configuration.yaml -n opa
   >    ```
   >    
   >    ```
   >    # ingress-whitelist.rego
   >    package kubernetes.admission
   >    
   >    import data.kubernetes.namespaces
   >    
   >    operations = {"CREATE", "UPDATE"}
   >    
   >    deny[msg] {
   >    	input.request.kind.kind == "Ingress"
   >    	operations[input.request.operation]
   >    	host := input.request.object.spec.rules[_].host
   >    	not fqdn_matches_any(host, valid_ingress_hosts)
   >    	msg := sprintf("invalid ingress host %q", [host])
   >    }
   >    
   >    valid_ingress_hosts = {host |
   >    	whitelist := namespaces[input.request.namespace].metadata.annotations["ingress-whitelist"]
   >    	hosts := split(whitelist, ",")
   >    	host := hosts[_]
   >    }
   >    
   >    fqdn_matches_any(str, patterns) {
   >    	fqdn_matches(str, patterns[_])
   >    }
   >    
   >    fqdn_matches(str, pattern) {
   >    	pattern_parts := split(pattern, ".")
   >    	pattern_parts[0] == "*"
   >    	str_parts := split(str, ".")
   >    	n_pattern_parts := count(pattern_parts)
   >    	n_str_parts := count(str_parts)
   >    	suffix := trim(pattern, "*.")
   >    	endswith(str, suffix)
   >    }
   >    
   >    fqdn_matches(str, pattern) {
   >        not contains(pattern, "*")
   >        str == pattern
   >    }
   >    ```
   >    
   >    ```
   >    kubectl create configmap ingress-whitelist --from-file=ingress-whitelist.rego -n opa
   >    ```
   >    
   >    https://play.openpolicyagent.org/


