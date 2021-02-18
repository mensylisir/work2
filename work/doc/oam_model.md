1. OAM 模型中包含以下基本对象，以本文发稿时的最新 API 版本 core.oam.dev/v1alpha2 为准：
> - Component：OAM 中最基础的对象，该配置与基础设施无关，定义负载实例的运维特性。例如一个微服务 workload 的定义。
> - TraitDefinition：一个组件所需的运维策略与配置，例如环境变量、Ingress、AutoScaler、Volume 等。（注意：该对象在 apiVersion: core.oam.dev/v1alpha1 中的名称为 Trait）。
> - ScopeDefinition：多个 Component 的共同边界。可以根据组件的特性或者作用域来划分 Scope，一个 Component 可能同时属于多个 Scope。
> - ApplicationConfiguration：将 Component（必须）、Trait（必须）、Scope（非必须）等组合到一起形成一个完整的应用配置。


2. 部署oam应用
> - WorkloadDefinition
```
apiVersion: core.oam.dev/v1alpha2
kind: WorkloadDefinition
metadata:
  name: containerizedworkloads.core.oam.dev
spec:
  definitionRef:
    name: containerizedworkloads.core.oam.dev
  childResourceKinds:
    - apiVersion: apps/v1
      kind: Deployment
    - apiVersion: v1
      kind: Service
```
> - TraitDefinition
```
apiVersion: core.oam.dev/v1alpha2
kind: TraitDefinition
metadata:
  name: manualscalertraits.core.oam.dev
spec:
  definitionRef:
    name: manualscalertraits.core.oam.dev
```
> - Component
```
apiVersion: core.oam.dev/v1alpha2
kind: Component
metadata:
  name: mysql-component
spec:
  workload:
    apiVersion: core.oam.dev/v1alpha2
    kind: ContainerizedWorkload
    spec:
      containers:
        - name: mysql
          image: 192.168.80.54:8081/library/mysql:8.0.11
          ports:
            - containerPort: 3306
              name: mysql
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: 'root123'
  parameters:
    - name: instance-name
      required: true
      fieldPaths:
        - metadata.name
    - name: image
      fieldPaths:
        - spec.containers[0].image
```
> - ApplicationConfiguration
```
apiVersion: core.oam.dev/v1alpha2
kind: ApplicationConfiguration
metadata:
  name: mysql-appconfig
spec:
  components:
    - componentName: mysql-component
      parameterValues:
        - name: instance-name
          value: mysql-appconfig-workload
      traits:
        - trait:
            apiVersion: core.oam.dev/v1alpha2
            kind: ManualScalerTrait
            metadata:
              name:  mysql-appconfig-trait
            spec:
              replicaCount: 1
```