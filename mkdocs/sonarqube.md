1. 部署sonarqube

   ```yaml
   ---
   
   kind: PersistentVolumeClaim
   apiVersion: v1
   metadata:
     name: postgrespvc
     namespace: jenkins
     labels:
       app: postgres
   spec:
     accessModes:
       - "ReadWriteOnce"
     resources:
       requests:
         storage: "4Gi"
     storageClassName: "nfs-client"
   ---
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: postgres
     namespace: jenkins
     labels:
       app: postgres
   spec:
     selector:
       matchLabels:
         app: postgres
     template:
       metadata:
         name: postgres
         labels:
           app: postgres
       spec:
         containers:
         - name: postgres
           image: 192.168.80.54:8081/library/postgres:9.6.8
           ports:
             - containerPort: 5432
           env:
             - name: POSTGRES_USER
               value: sonar
             - name: POSTGRES_PASSWORD
               value: sonar
           volumeMounts:
           - mountPath: /var/lib/postgresql/data
             name: postgres-data
         volumes:
         - name: postgres-data
           persistentVolumeClaim:
             claimName: postgrespvc
   ---
   apiVersion: v1
   kind: Service
   metadata:
     name: postgres
     namespace: jenkins
     labels:
       app: postgres
   spec:
     type: NodePort
     ports:
     - port: 5432
     selector:
       app: postgres
   ---
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: sonar
     namespace: jenkins
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: sonar
     template:
       metadata:
         labels:
           app: sonar
       spec:
         containers:
         - name: sonar
           image: 192.168.80.54:8081/library/sonarqube:7.4-community
           ports:
           - containerPort: 9000
           env:
           - name: SONARQUBE_JDBC_USERNAME
             value: sonar
           - name: SONARQUBE_JDBC_PASSWORD
             value: sonar
           - name: SONARQUBE_JDBC_URL
             value: jdbc:postgresql://postgres:5432/sonar
   ---
   apiVersion: v1
   kind: Service
   metadata:
     name: sonar
     namespace: jenkins
   spec:
     type: NodePort
     ports:
     - port: 9000
       nodePort: 30001
     selector:
       app: sonar
   ```

2. pom中增加如下：

   ```xml
              <plugin>
                   <groupId>org.sonarsource.scanner.maven</groupId>
                   <artifactId>sonar-maven-plugin</artifactId>
                   <version>3.7.0.1746</version>
             </plugin>
   ```

3. 扫描

   ```shell
   mvn sonar:sonar -Dsonar.host.url=http://192.168.80.79:30001 -Dsonar.login=83b9ecd042ebf64521d9fbf43124b44a8c2047a2
   ```