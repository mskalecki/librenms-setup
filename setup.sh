#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mkdir -p /var/librenms
cp --update=none $SCRIPT_DIR/config/{.env,librenms.env,msmtpd.env,compose.yml,Caddyfile,init-lnms-config.sh} /var/librenms/
chmod 600 /var/librenms/.env /var/librenms/msmtpd.env