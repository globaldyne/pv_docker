#!/bin/bash

echo "Starting web server"

mkdir /tmp/php

if [ ! -d $TMP_PATH ] 
then
    echo "Temp directory not exists, creating $TMP_PATH." 
    mkdir -p $TMP_PATH
fi

php-fpm
nginx -e /tmp/error.log
tail -f /tmp/*.log
