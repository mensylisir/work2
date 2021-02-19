## 配置

```
{
        "version": "10",
        "aliases": {
                "gcs": {
                        "url": "https://storage.googleapis.com",
                        "accessKey": "YOUR-ACCESS-KEY-HERE",
                        "secretKey": "YOUR-SECRET-KEY-HERE",
                        "api": "S3v2",
                        "path": "dns"
                },
                "local": {
                        "url": "http://localhost:9000",
                        "accessKey": "",
                        "secretKey": "",
                        "api": "S3v4",
                        "path": "auto"
                },
                "play": {
                        "url": "https://play.min.io",
                        "accessKey": "Q3AM3UQ867SPQQA43P2F",
                        "secretKey": "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG",
                        "api": "S3v4",
                        "path": "auto"
                },
                "s3": {
                        "url": "https://s3.amazonaws.com",
                        "accessKey": "YOUR-ACCESS-KEY-HERE",
                        "secretKey": "YOUR-SECRET-KEY-HERE",
                        "api": "S3v4",
                        "path": "dns"
                },
                "minio": {
                        "url": "https://minio.dev.rdev.tech",
                        "accessKey": "minio",
                        "secretKey": "minio123",
                        "api": "S3v4",
                        "path": "auto"
                }
        }
}
```

## 设置后台实时监控

```
#修改成你需要实时同步备份的文件夹
backup="/data/gitlab-data/backups/"
#修改成你要备份到的存储桶
bucket="gitlab-backup"
#将以下代码一起复制到SSH运行
cat > /etc/systemd/system/minioc.service <<EOF
[Unit]
Description=minioc
After=network.target

[Service]
Type=simple
ExecStart=$(command -v mc) --insecure mirror -w ${backup} minio/${bucket}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
```

## 恢复数据

```
bundle exec rake gitlab:backup:restore BACKUP=1611821819_2021_01_28_13.6.0
```

