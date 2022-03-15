#!/bin/bash
USERID=`id -u mariadb`
GROUPID=`id -g mariadb`
docker stop mariadb
docker rm mariadb
# initial root password only on first container creation
# change root password afterwards to a secure one by running
# mysql --host localhost --protocol=tcp --port=3306 --user root -p
# ALTER USER 'root'@'localhost' IDENTIFIED BY 'NewSecPw';
#docker run -d --name mariadb -v /srv/mariadb/data/:/var/lib/mysql -p 3306:3306 -e MYSQL_LOG_CONSOLE=true -e MARIADB_ROOT_PASSWORD=my-secret-pw --restart=unless-stopped -u $USERID:$GROUPID mariadb:10
docker run -d --name mariadb -v /srv/mariadb/data/:/var/lib/mysql -p 3306:3306 -e MYSQL_LOG_CONSOLE=true --restart=unless-stopped -u $USERID:$GROUPID mariadb:10
