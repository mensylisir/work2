1. 生成keystore
```
keytool -genkey -v -keystore my-release-key.keystore -alias myrelease -keyalg RSA -keysize 2048 -validity 10000
```
2. 签名
```
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1
-keystore my-release-key.keystore my_application.apk alias_name
```
3. 安装
```
adb install -r <path_to_apk>
```