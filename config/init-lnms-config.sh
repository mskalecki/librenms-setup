#!/bin/bash

# Set variables
hostname="librenms"
domain="<web_domain>"
email_from="<web_domain>"
nets='["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16"]'
snmp_v3_user=librenms
snmp_v3_sha=<authsha>
snmp_v3_aes=<cryptosha>
snmp_v2='["public"]'
# If the switches live in a different domain than the server, change the next line
search_domain=$domain
# End set variables

# msmtpd -- uncomment below if using email notifications
# sudo docker compose exec --user librenms librenms lnms config:set email_smtp_host msmtpd
# sudo docker compose exec --user librenms librenms lnms config:set email_smtp_port 2500
# sudo docker compose exec --user librenms librenms lnms config:set email_auto_tls true
# sudo docker compose exec --user librenms librenms lnms config:set email_backend smtp
# sudo docker compose exec --user librenms librenms lnms config:set email_from $email_from


sudo docker compose exec --user librenms librenms lnms config:cache
sudo docker compose exec --user librenms librenms lnms config:set own_hostname "$hostname.$domain"

# Comment out the block below if not using snmp_v3
sudo docker compose exec --user librenms librenms lnms config:set snmp.v3.0.authalgo "SHA"
sudo docker compose exec --user librenms librenms lnms config:set snmp.v3.0.authlevel "authPriv"
sudo docker compose exec --user librenms librenms lnms config:set snmp.v3.0.authname "$snmp_v3_user"
sudo docker compose exec --user librenms librenms lnms config:set snmp.v3.0.authpass "$snmp_v3_sha"
sudo docker compose exec --user librenms librenms lnms config:set snmp.v3.0.cryptoalgo "AES"
sudo docker compose exec --user librenms librenms lnms config:set snmp.v3.0.cryptopass "$snmp_v3_aes"

# snmp_v2
sudo docker compose exec --user librenms librenms lnms config:set snmp.community $snmp_v2

# Discovery
sudo docker compose exec --user librenms librenms lnms config:set nets $nets
sudo docker compose exec --user librenms librenms lnms config:set mydomain $search_domain

# Microsoft Entra SSO; private fields will be updated in Gui
sudo docker compose exec --user librenms librenms lnms config:set auth.socialite.register true
sudo docker compose exec --user librenms librenms lnms config:set auth.socialite.default_role none
sudo docker compose exec --user librenms librenms lnms config:set auth.socialite.configs.microsoft '{
    "client_id": "<client_id>",
    "client_secret": "<client_secret>",
    "tenant": "<tenant>",
    "listener": "\\SocialiteProviders\\Microsoft\\MicrosoftExtendSocialite",
    "include_tenant_info": false
}'

# https://docs.librenms.org/Extensions/Oxidized/
sudo docker compose exec --user librenms librenms lnms config:set oxidized.enabled true
sudo docker compose exec --user librenms librenms lnms config:set oxidized.default_group default
sudo docker compose exec --user librenms librenms lnms config:set oxidized.group_support true
sudo docker compose exec --user librenms librenms lnms config:set oxidized.reload_nodes true
sudo docker compose exec --user librenms librenms lnms config:set oxidized.features.versioning true
sudo docker compose exec --user librenms librenms lnms config:set oxidized.url http://oxidized.librenms_default:8888