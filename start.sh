#!/bin/bash

WEBDIR="/html"

if [ ! -d "/config" ]; then
	mkdir -p /config
	cp ${WEBDIR}/inc/* /config/
fi

touch /config/.DOCKER

if [ -f "/config/config.php" ]; then
	ln -s /config/config.php ${WEBDIR}/inc/config.php
fi


echo "----------------------------------"
echo "READY - Perfumer's Vault Ver $(cat /html/VERSION.md)"
echo "----------------------------------"
echo "Starting web server"
/usr/bin/php -S 0.0.0.0:8000 -t ${WEBDIR}
