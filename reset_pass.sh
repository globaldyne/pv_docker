#!/bin/sh
#
#
# Reset admin pass
# Script Version: v1.0
# Author: John Belekios <john@globaldyne.co.uk>
#
#


PASS=$(openssl rand -hex 8)

mysql -h localhost -upvault -ppvault pvault -e \
  "UPDATE users SET password = PASSWORD('$PASS') WHERE id = '1';"

clear
echo New Password is: $PASS
