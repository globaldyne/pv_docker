#!/bin/bash

MYSQL_DB="pvault"
MYSQL_USER="pvault"
MYSQL_PASS="pvault"
DATADIR="/var/lib/mysql"
WEBDIR="/var/www/html"

if [ -d "$WEBDIR/helpers" ]; then
	rm -rf "$WEBDIR/helpers"
fi

if [ ! -d "/config" ]; then
	mkdir -p /config
fi

if [ ! -d "$DATADIR/mysql" ]; then
	echo "Initializing DB"
	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /tmp/my.log 2>&1
	/usr/bin/mysqld_safe  --init-file=/tmp/mysql-first-time.sql & >> /tmp/my.log 2>&1
	echo "Waiting for DB to start"
	sleep 10
	echo "Importing default schema"
	mysql -u$MYSQL_USER -p$MYSQL_PASS $MYSQL_DB < /var/www/html/db/pvault.sql
fi

echo "Setting enviroment"
if [ ! -f "/config/config.php" ]; then
	cp /var/www/html/inc/config.example.php /config/config.php
	ln -s /config/config.php /var/www/html/inc/config.php
else
	ln -s /config/config.php /var/www/html/inc/config.php
fi

echo "Setting permissions"
chown -R mysql:mysql /var/lib/mysql

echo "Starting DB"
/usr/bin/mysqld_safe &

echo "----------------------------------"
echo "READY - Perfumer's Vault Ver $(cat /var/www/html/VERSION.md)"
echo "----------------------------------"
echo "Starting web server"
/usr/bin/php -S 0.0.0.0:8000 -t /var/www/html/
