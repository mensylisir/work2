### gitlab-api

1. 获取所有的用户组

   ```shell
   curl  --header "PRIVATE-TOKEN:VmyM5da8WQ7bCP6j-8Sj" https://gitlab.rdev.tech/api/v4/groups -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem | jq
   ```

   ```json
   [
     {
       "id": 10,
       "name": "bs-template",
       "path": "bs-template",
       "description": "",
       "visibility": "private",
       "lfs_enabled": true,
       "avatar_url": null,
       "web_url": "https://gitlab.rdev.tech/groups/bs-template",
       "request_access_enabled": false,
       "full_name": "bs-template",
       "full_path": "bs-template",
       "parent_id": null
     },
     {
       "id": 4,
       "name": "mkdoc",
       "path": "mkdoc",
       "description": "",
       "visibility": "public",
       "lfs_enabled": true,
       "avatar_url": null,
       "web_url": "https://gitlab.rdev.tech/groups/mkdoc",
       "request_access_enabled": false,
       "full_name": "mkdoc",
       "full_path": "mkdoc",
       "parent_id": null
     },
     {
       "id": 9,
       "name": "rdev_group",
       "path": "rdev_group",
       "description": "",
       "visibility": "private",
       "lfs_enabled": true,
       "avatar_url": null,
       "web_url": "https://gitlab.rdev.tech/groups/rdev_group",
       "request_access_enabled": false,
       "full_name": "rdev_group",
       "full_path": "rdev_group",
       "parent_id": null
     }
   ]
   ```

2. 获取所有用户

   ```shell
   curl  --header "PRIVATE-TOKEN:VmyM5da8WQ7bCP6j-8Sj" https://gitlab.rdev.tech/api/v4/users -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem | jq
   ```

   ```json
   [
     {
       "name": "wangqiang",
       "username": "wangqiang",
       "id": 9,
       "state": "active",
       "avatar_url": "https://secure.gravatar.com/avatar/ab3c16251b76fc996fa900aab552964e?s=80&d=identicon",
       "web_url": "https://gitlab.rdev.tech/wangqiang",
       "created_at": "2020-12-21T00:31:05.748Z",
       "bio": null,
       "location": null,
       "skype": "",
       "linkedin": "",
       "twitter": "",
       "website_url": "",
       "organization": null,
       "last_sign_in_at": "2020-12-21T00:31:05.788Z",
       "confirmed_at": "2020-12-21T00:31:05.730Z",
       "last_activity_on": null,
       "email": "wangqiang@rdev.tech",
       "color_scheme_id": 1,
       "projects_limit": 100000,
       "current_sign_in_at": "2020-12-21T00:31:05.788Z",
       "identities": [
         {
           "provider": "saml",
           "extern_uid": "wangqiang"
         }
       ],
       "can_create_group": true,
       "can_create_project": true,
       "two_factor_enabled": false,
       "external": false,
       "is_admin": false
     },
     {
       "name": "liminggang8",
       "username": "liminggang8",
       "id": 8,
       "state": "active",
       "avatar_url": "https://secure.gravatar.com/avatar/22bceab79ac6b95b309b0aae1780f8f7?s=80&d=identicon",
       "web_url": "https://gitlab.rdev.tech/liminggang8",
       "created_at": "2020-12-18T01:37:40.868Z",
       "bio": null,
       "location": null,
       "skype": "",
       "linkedin": "",
       "twitter": "",
       "website_url": "",
       "organization": null,
       "last_sign_in_at": "2020-12-18T01:37:40.930Z",
       "confirmed_at": "2020-12-18T01:37:40.840Z",
       "last_activity_on": null,
       "email": "temp-email-for-oauth-liminggang8@gitlab.localhost",
       "color_scheme_id": 1,
       "projects_limit": 100000,
       "current_sign_in_at": "2020-12-18T08:50:39.574Z",
       "identities": [
         {
           "provider": "saml",
           "extern_uid": "liminggang8"
         }
       ],
       "can_create_group": true,
       "can_create_project": true,
       "two_factor_enabled": false,
       "external": false,
       "is_admin": false
     },
     {
       "name": "my",
       "username": "test",
       "id": 7,
       "state": "active",
       "avatar_url": "https://secure.gravatar.com/avatar/a99aeac9017e79611c35523d78af26a9?s=80&d=identicon",
       "web_url": "https://gitlab.rdev.tech/test",
       "created_at": "2020-12-17T07:51:28.557Z",
       "bio": null,
       "location": null,
       "skype": "",
       "linkedin": "",
       "twitter": "",
       "website_url": "",
       "organization": null,
       "last_sign_in_at": "2020-12-17T07:51:28.588Z",
       "confirmed_at": "2020-12-17T07:51:28.536Z",
       "last_activity_on": "2020-12-18",
       "email": "mengyuan@rdev.com",
       "color_scheme_id": 1,
       "projects_limit": 100000,
       "current_sign_in_at": "2020-12-18T03:32:42.152Z",
       "identities": [],
       "can_create_group": true,
       "can_create_project": true,
       "two_factor_enabled": false,
       "external": false,
       "is_admin": false
     },
     {
       "name": "wangqiang",
       "username": "wangq",
       "id": 6,
       "state": "active",
       "avatar_url": "https://secure.gravatar.com/avatar/d3b9894cdd9b0787125344950cb0ed2f?s=80&d=identicon",
       "web_url": "https://gitlab.rdev.tech/wangq",
       "created_at": "2020-12-17T03:00:38.716Z",
       "bio": "",
       "location": "",
       "skype": "",
       "linkedin": "",
       "twitter": "",
       "website_url": "",
       "organization": "",
       "last_sign_in_at": "2020-12-18T09:27:31.978Z",
       "confirmed_at": "2020-12-17T03:00:38.701Z",
       "last_activity_on": "2020-12-21",
       "email": "89414266@qq.com",
       "color_scheme_id": 1,
       "projects_limit": 100000,
       "current_sign_in_at": "2020-12-21T00:28:23.699Z",
       "identities": [],
       "can_create_group": true,
       "can_create_project": true,
       "two_factor_enabled": false,
       "external": false,
       "is_admin": true
     },
     {
       "name": "huixiaoying",
       "username": "huixiaoying",
       "id": 5,
       "state": "active",
       "avatar_url": "https://secure.gravatar.com/avatar/10f0bba4acf93614df8d701c8cc4a5dd?s=80&d=identicon",
       "web_url": "https://gitlab.rdev.tech/huixiaoying",
       "created_at": "2020-12-16T08:27:20.482Z",
       "bio": null,
       "location": null,
       "skype": "",
       "linkedin": "",
       "twitter": "",
       "website_url": "",
       "organization": null,
       "last_sign_in_at": "2020-12-16T08:27:20.522Z",
       "confirmed_at": "2020-12-16T08:27:20.465Z",
       "last_activity_on": null,
       "email": "huixiaoying@dev.com",
       "color_scheme_id": 1,
       "projects_limit": 100000,
       "current_sign_in_at": "2020-12-16T08:27:20.522Z",
       "identities": [
         {
           "provider": "saml",
           "extern_uid": "huixiaoying"
         }
       ],
       "can_create_group": true,
       "can_create_project": true,
       "two_factor_enabled": false,
       "external": false,
       "is_admin": false
     },
     {
       "name": "liminggang2",
       "username": "liminggang2",
       "id": 4,
       "state": "active",
       "avatar_url": "https://secure.gravatar.com/avatar/c313ead4a72ef4e512fdd66471eeddc1?s=80&d=identicon",
       "web_url": "https://gitlab.rdev.tech/liminggang2",
       "created_at": "2020-12-16T06:55:17.465Z",
       "bio": null,
       "location": null,
       "skype": "",
       "linkedin": "",
       "twitter": "",
       "website_url": "",
       "organization": null,
       "last_sign_in_at": "2020-12-16T06:55:17.505Z",
       "confirmed_at": "2020-12-16T06:55:17.441Z",
       "last_activity_on": null,
       "email": "liminggang2@rdev.tech",
       "color_scheme_id": 1,
       "projects_limit": 100000,
       "current_sign_in_at": "2020-12-16T06:55:17.505Z",
       "identities": [
         {
           "provider": "saml",
           "extern_uid": "liminggang2"
         }
       ],
       "can_create_group": true,
       "can_create_project": true,
       "two_factor_enabled": false,
       "external": false,
       "is_admin": false
     },
     {
       "name": "liminggang",
       "username": "liminggang",
       "id": 3,
       "state": "active",
       "avatar_url": "https://secure.gravatar.com/avatar/05c8f7426da9b26aba7140a56fd15dca?s=80&d=identicon",
       "web_url": "https://gitlab.rdev.tech/liminggang",
       "created_at": "2020-12-16T06:45:20.727Z",
       "bio": null,
       "location": null,
       "skype": "",
       "linkedin": "",
       "twitter": "",
       "website_url": "",
       "organization": null,
       "last_sign_in_at": "2020-12-18T03:31:51.236Z",
       "confirmed_at": "2020-12-16T06:45:20.679Z",
       "last_activity_on": "2020-12-21",
       "email": "mensyli@dingtalk.com",
       "color_scheme_id": 1,
       "projects_limit": 100000,
       "current_sign_in_at": "2020-12-21T00:21:59.897Z",
       "identities": [
         {
           "provider": "saml",
           "extern_uid": "liminggang"
         }
       ],
       "can_create_group": true,
       "can_create_project": true,
       "two_factor_enabled": false,
       "external": false,
       "is_admin": false
     },
     {
       "name": "yanghaichao",
       "username": "yanghaichao",
       "id": 2,
       "state": "active",
       "avatar_url": "https://secure.gravatar.com/avatar/021f04e5d8cdb987dfa363a2d646da6e?s=80&d=identicon",
       "web_url": "https://gitlab.rdev.tech/yanghaichao",
       "created_at": "2020-12-16T06:21:30.720Z",
       "bio": null,
       "location": null,
       "skype": "",
       "linkedin": "",
       "twitter": "",
       "website_url": "",
       "organization": null,
       "last_sign_in_at": "2020-12-17T03:24:36.553Z",
       "confirmed_at": "2020-12-16T06:21:30.690Z",
       "last_activity_on": "2020-12-18",
       "email": "yanghaichao@rdev.tech",
       "color_scheme_id": 1,
       "projects_limit": 100000,
       "current_sign_in_at": "2020-12-18T09:04:56.574Z",
       "identities": [
         {
           "provider": "saml",
           "extern_uid": "yanghaichao"
         }
       ],
       "can_create_group": true,
       "can_create_project": true,
       "two_factor_enabled": false,
       "external": false,
       "is_admin": false
     },
     {
       "name": "Administrator",
       "username": "root",
       "id": 1,
       "state": "active",
       "avatar_url": "https://secure.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon",
       "web_url": "https://gitlab.rdev.tech/root",
       "created_at": "2020-12-16T06:08:17.209Z",
       "bio": "",
       "location": "",
       "skype": "",
       "linkedin": "",
       "twitter": "",
       "website_url": "",
       "organization": "",
       "last_sign_in_at": "2020-12-18T08:46:28.721Z",
       "confirmed_at": "2020-12-16T06:08:16.813Z",
       "last_activity_on": "2020-12-21",
       "email": "admin@example.com",
       "color_scheme_id": 1,
       "projects_limit": 100000,
       "current_sign_in_at": "2020-12-21T00:28:57.193Z",
       "identities": [],
       "can_create_group": true,
       "can_create_project": true,
       "two_factor_enabled": false,
       "external": false,
       "is_admin": true
     }
   ]
   ```

3. 创建项目

   ```shell
   curl  --request POST --header "PRIVATE-TOKEN:VmyM5da8WQ7bCP6j-8Sj" --data "name=liminggang&namespace_id=4" https://gitlab.rdev.tech/api/v4/projects -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem
   ```

   ```json
   {
   	"id": 7,
   	"description": null,
   	"default_branch": null,
   	"tag_list": [],
   	"archived": false,
   	"visibility": "private",
   	"ssh_url_to_repo": "git@gitlab.rdev.tech:mkdoc/liminggang.git",
   	"http_url_to_repo": "https://gitlab.rdev.tech/mkdoc/liminggang.git",
   	"web_url": "https://gitlab.rdev.tech/mkdoc/liminggang",
   	"name": "liminggang",
   	"name_with_namespace": "mkdoc / liminggang",
   	"path": "liminggang",
   	"path_with_namespace": "mkdoc/liminggang",
   	"container_registry_enabled": true,
   	"issues_enabled": true,
   	"merge_requests_enabled": true,
   	"wiki_enabled": true,
   	"jobs_enabled": true,
   	"snippets_enabled": true,
   	"created_at": "2020-12-21T00:59:44.701Z",
   	"last_activity_at": "2020-12-21T00:59:44.701Z",
   	"shared_runners_enabled": true,
   	"lfs_enabled": true,
   	"creator_id": 1,
   	"namespace": {
   		"id": 4,
   		"name": "mkdoc",
   		"path": "mkdoc",
   		"kind": "group",
   		"full_path": "mkdoc",
   		"parent_id": null
   	},
   	"import_status": "none",
   	"import_error": null,
   	"avatar_url": null,
   	"star_count": 0,
   	"forks_count": 0,
   	"open_issues_count": 0,
   	"runners_token": "LRGJwzqzeasoD_etUFnY",
   	"public_jobs": true,
   	"ci_config_path": null,
   	"shared_with_groups": [],
   	"only_allow_merge_if_pipeline_succeeds": false,
   	"request_access_enabled": false,
   	"only_allow_merge_if_all_discussions_are_resolved": false,
   	"printing_merge_request_link_enabled": true
   }
   ```

4. 查看namespace

   ```
   curl  --header "PRIVATE-TOKEN:VmyM5da8WQ7bCP6j-8Sj" https://gitlab.rdev.tech/api/v4/namespaces -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem | jq
   ```

   ```
   [
     {
       "id": 12,
       "name": "wangqiang",
       "path": "wangqiang",
       "kind": "user",
       "full_path": "wangqiang",
       "parent_id": null
     },
     {
       "id": 11,
       "name": "liminggang8",
       "path": "liminggang8",
       "kind": "user",
       "full_path": "liminggang8",
       "parent_id": null
     },
     {
       "id": 10,
       "name": "bs-template",
       "path": "bs-template",
       "kind": "group",
       "full_path": "bs-template",
       "parent_id": null,
       "members_count_with_descendants": 4
     },
     {
       "id": 9,
       "name": "rdev_group",
       "path": "rdev_group",
       "kind": "group",
       "full_path": "rdev_group",
       "parent_id": null,
       "members_count_with_descendants": 1
     },
     {
       "id": 8,
       "name": "test",
       "path": "test",
       "kind": "user",
       "full_path": "test",
       "parent_id": null
     },
     {
       "id": 7,
       "name": "wangq",
       "path": "wangq",
       "kind": "user",
       "full_path": "wangq",
       "parent_id": null
     },
     {
       "id": 6,
       "name": "huixiaoying",
       "path": "huixiaoying",
       "kind": "user",
       "full_path": "huixiaoying",
       "parent_id": null
     },
     {
       "id": 5,
       "name": "liminggang2",
       "path": "liminggang2",
       "kind": "user",
       "full_path": "liminggang2",
       "parent_id": null
     },
     {
       "id": 4,
       "name": "mkdoc",
       "path": "mkdoc",
       "kind": "group",
       "full_path": "mkdoc",
       "parent_id": null,
       "members_count_with_descendants": 6
     },
     {
       "id": 3,
       "name": "liminggang",
       "path": "liminggang",
       "kind": "user",
       "full_path": "liminggang",
       "parent_id": null
     },
     {
       "id": 2,
       "name": "yanghaichao",
       "path": "yanghaichao",
       "kind": "user",
       "full_path": "yanghaichao",
       "parent_id": null
     },
     {
       "id": 1,
       "name": "root",
       "path": "root",
       "kind": "user",
       "full_path": "root",
       "parent_id": null
     }
   ]
   ```


5. 创建分支

   ```
   curl  --request POST --header "PRIVATE-TOKEN:VmyM5da8WQ7bCP6j-8Sj" "https://gitlab.rdev.tech/api/v4/projects/4/repository/branches?branch=newbranch1&ref=master" -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --ke
   y /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem | jq
   ```

   ```
   {
     "name": "newbranch1",
     "commit": {
       "id": "bd4f1afd899295d74488f506028bd90c061dd783",
       "short_id": "bd4f1afd",
       "title": "feat:添加模板",
       "created_at": "2020-12-18T09:45:15.000+08:00",
       "parent_ids": [
         "267164382b1c89076411d7c812b04d3fdbd62b26"
       ],
       "message": "feat:添加模板\n",
       "author_name": "wangqiang",
       "author_email": "89414266@qq.com",
       "authored_date": "2020-12-18T09:45:15.000+08:00",
       "committer_name": "wangqiang",
       "committer_email": "89414266@qq.com",
       "committed_date": "2020-12-18T09:45:15.000+08:00"
     },
     "merged": false,
     "protected": false,
     "developers_can_push": false,
     "developers_can_merge": false
   }
   ```

   

6. 创建commit

   ```
   curl  --request POST --header "PRIVATE-TOKEN:VmyM5da8WQ7bCP6j-8Sj" --header "Content-Type: application/json" --data "$PAYLOAD" "https://gitlab.rdev.tech/api/v4/projects/4/repository/commits" -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem | jq
   ```

   ```
   PAYLOAD=$(cat << 'JSON'
   {
     "branch": "master",
     "commit_message": "some commit message",
     "actions": [
       {
         "action": "create",
         "file_path": "foo/bar",
         "content": "some content"
       }
     ]
   }
   JSON
   )
   ```

   ```
   {
     "id": "7b23f721f262ba57110280c6cc2f57701a4992e0",
     "short_id": "7b23f721",
     "title": "some commit message",
     "created_at": "2020-12-23T07:19:26.000+00:00",
     "parent_ids": [
       "bd4f1afd899295d74488f506028bd90c061dd783"
     ],
     "message": "some commit message",
     "author_name": "Administrator",
     "author_email": "admin@example.com",
     "authored_date": "2020-12-23T07:19:26.000+00:00",
     "committer_name": "Administrator",
     "committer_email": "admin@example.com",
     "committed_date": "2020-12-23T07:19:26.000+00:00",
     "stats": {
       "additions": 1,
       "deletions": 0,
       "total": 1
     },
     "status": null
   }
   ```

   

7. 获取分支

   ```
   curl --header "PRIVATE-TOKEN: VmyM5da8WQ7bCP6j-8Sj" "https://gitlab.rdev.tech/api/v4/projects/4/repository/branches" -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem | jq
   
   curl  --request POST --header "PRIVATE-TOKEN:VmyM5da8WQ7bCP6j-8Sj" --header "Content-Type: application/json" --data "$PAYLOAD" "https://gitlab.rdev.tech/api/v4/projects/4/repository/commits" -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem | jq
   ```

   

---------

```
curl  --header "PRIVATE-TOKEN:8zAz8WLy39BDz7my1Gyu" https://gitlab-dev2.rdev.tech/api/v4/namespaces -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem | jq
```

```
curl --header "PRIVATE-TOKEN:8zAz8WLy39BDz7my1Gyu" "https://gitlab-dev2.rdev.tech/api/v4/projects/2/repository/branches" -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem | jq
```

```
curl  --request POST --header "PRIVATE-TOKEN:hUP16o9JTrEmMxdQo6KF" "https://gitlab-dev2.rdev.tech/api/v4/projects/2/repository/branches?branch=newbranch2&ref=master" -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem | jq
```

```
curl --header "PRIVATE-TOKEN: 1oeJHVudqsz9Btxwymjy" --remote-header-name --remote-name "https://gitlab-dev2.rdev.tech/api/v4/projects/2/export/download" -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem | jq
```

```
curl --request POST --header "PRIVATE-TOKEN: 1oeJHVudqsz9Btxwymjy" --form "path=heheda" --form "file=@/home/mensyli1/work/hehe/2020-12-31_06-36-489_root_test_export.tar.gz" "https://gitlab-dev2.rdev.tech/api/v4/projects/import"  -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem
```

```
curl --header "PRIVATE-TOKEN: 1oeJHVudqsz9Btxwymjy" "https://gitlab-dev2.rdev.tech/api/v4/projects/8/repository/files/components%2Fcomponent.yaml?ref=master" -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem
```

```
https://gitlab-dev2.rdev.tech/api/v4/projects/backstage%2Fbackstage_exa
```

```
curl --header "PRIVATE-TOKEN: 1oeJHVudqsz9Btxwymjy" "https://gitlab-dev2.rdev.tech/api/v4/projects/backstage%2Fbackstage_exa" -k --cert /mnt/d/Workspace/rdev.tech-ssl/ca/ca.pem --key /mnt/d/Workspace/rdev.tech-ssl/ca/ca-key.pem
```

