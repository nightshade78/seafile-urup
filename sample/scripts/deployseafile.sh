#!/bin/bash
USERID=`id -u seafile`
GROUPID=`id -g seafile`
docker stop seafile
docker rm seafile
# settings only need to be given for a fresh installation / first-time container
#docker run -d --name seafile -p 8082:8082/tcp -p 8000:8000/tcp  -p 8083:8083/tcp -v /data/seafile:/shared -e TIME_ZONE=Europe/Berlin -e DB_HOST=mariadb -e DB_ROOT_PASSWD=my-secret-pw -e SEAFILE_ADMIN_EMAIL=admin@domain.tld -e SEAFILE_ADMIN_PASSWORD=asecret -e SEAFILE_SERVER_HOSTNAME=seafilehost.domain.local --link memcache:memcached --link mariadb --restart=unless-stopped seafile-urup-customuser:latest
docker run -d --name seafile -p 8082:8082/tcp -p 8000:8000/tcp  -p 8083:8083/tcp -v /data/seafile:/shared -e TIME_ZONE=Europe/Berlin --link memcache:memcached --link mariadb --restart=unless-stopped -u $USERID:$GROUPID seafile-urup-customuser:latest
