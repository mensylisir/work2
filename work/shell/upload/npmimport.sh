#!/bin/bash
# copy and run this script to the root of the repository directory containing files
# this script attempts to exclude uploading itself explicitly so the script name is important
# Get command line params
# 上传依赖包
ls -1 -I"_*" -I"*.sh" -I"@*" | while read line
do
npm publish $line
done
# 上传范围依赖包，@前缀双层目录结构
ls -1 -I"_*" -I"*.sh" @* | while read line
do
	result=$(echo $line | grep "@")
	if [[ "$result" != "" ]]
	then
		group=${line%?}
	elif [[ "$line" = "" ]]
	then
		echo $group/$line
	else
		npm publish $group/$line
	fi
done
 

