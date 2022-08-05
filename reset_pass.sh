#!/bin/sh
#
#
# Reset admin pass
# Script Version: v1.2
# Author: John Belekios <john@globaldyne.co.uk>
#
#

PASS=$(openssl rand -hex 8)
VER=$(cat /var/www/html/VERSION.md)

if (( $(echo "$VER > 4.7" | bc -l) )); then
        mysql -h localhost -upvault -ppvault pvault -e \
                "UPDATE users SET password = '$PASS' WHERE id = '1';"

else
        mysql -h localhost -upvault -ppvault pvault -e \
                "UPDATE users SET password = PASSWORD('$PASS') WHERE id = '1';"
fi

clear
echo New Password is: $PASS
