拷贝mavenimport.sh到repository文件夹内执行
./mavenimport.sh -u admin -p abc123B, -r http://nexus.rdev.tech/repository/maven-releases/
上传npm私服
拷贝npmimport.sh到node_modules目录下执行
先login nexus.rdev.tech/repository/npm-l
npm login nexus.rdev.tech/repository/npm-l
admin  abc123B, admin@rdev.tech
./npmimport.sh

遗留问题:
1 目录前缀为@开头的是范围包，上传是@xx/xxx 二层目录上传，后续优化脚本  已解决
2 部分依赖包依赖其他版本号需要单独下载后上传
3 webpack-theme-color-replacer 此依赖包上传卡死，无法上传。
