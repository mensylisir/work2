```
curl \
  -H "Authorization: 576017a0-6e6a-4879-ab04-2a599cc7596b" \
  -F "file=/mnt/d/Workspace/MyApplication/app/build/outputs/apk/release/app-release-unsigned.apk" \
  -F "message=sample" \
  "https://deploygate.com/api/users/_your_name_/apps"
```