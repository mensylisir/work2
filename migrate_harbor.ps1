$array=@("harbor.rdev.tech/gt_zjk/tomcat:1.0", "harbor.rdev.tech/ccp-rail-base/nginx:1.15.5", "harbor.rdev.tech/ccp-rail-base/jre:1.8", "harbor.rdev.tech/ccp-rail-base/nginx:1.15.5", "harbor.rdev.tech/ccp-rail-base/tomcat:v8.5.54", "harbor.rdev.tech/ccp-rail-base/tomcat:v8.5.54", "harbor.rdev.tech/ccp-rail-base/tomcat:v8.5.54", "harbor.rdev.tech/ccp-rail-base/jre:1.8", "harbor.rdev.tech/ccp-rail-base/tomcat:v8.5.54", "harbor.rdev.tech/ccp-rail-base/tomcat:v8.5.54", "harbor.rdev.tech/ccp-rail-base/jre:1.8")
foreach($di in $array) {
	docker pull $di
	$new_tag=$($di -replace "harbor.rdev.tech", "192.168.80.54:8081")
	echo $new_tag
	Start-Sleep -Seconds 5
	docker login -u admin -p Harbor12345 http://192.168.80.54:8081/
	docker tag $di $new_tag
	docker push $new_tag
}