#!/bin/bash
mkdir /var/librenms
cp config/{.env,librenms.env,msmtpd.env,compose.yml,Caddyfile,lnms-config.sh} /var/librenms/
chmod 600 /var/librenms/.env /var/librenms/msmtpd.env