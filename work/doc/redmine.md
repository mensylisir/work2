```
docker run --name=postgresql-redmine -d \
  --env='DB_NAME=redmine_production' \
  --env='DB_USER=redmine' --env='DB_PASS=password' \
  --volume=/opt/redmine/postgresql:/var/lib/postgresql \
  harbor.rdev.tech/sameersbn/postgresql:9.6-4
```

```
docker run --name=redmine -d \
  --link=postgresql-redmine:postgresql --publish=10083:80 \
  --env='REDMINE_PORT=10083' \
  --volume=/opt/redmine/redmine:/home/redmine/data \
  --volume=/opt/redmine/redmine-logs:/var/log/redmine/ \
  harbor.rdev.tech/sameersbn/redmine:4.1.1-5
```

