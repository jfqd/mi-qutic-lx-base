#!/bin/bash
if /native/usr/sbin/mdata-get mail_smarthost 1>/dev/null 2>&1; then
  if /native/usr/sbin/mdata-get mail_adminaddr 1>/dev/null 2>&1; then
    echo "root: $(/native/usr/sbin/mdata-get mail_adminaddr)" >> /etc/aliases
    newaliases
  fi
  AUTH=""
  if /native/usr/sbin/mdata-get mail_auth_user 1>/dev/null 2>&1 && 
     /native/usr/sbin/mdata-get mail_auth_pass 1>/dev/null 2>&1; then
    AUTH="--user=$(/native/usr/sbin/mdata-get mail_auth_user) --pass=$(/native/usr/sbin/mdata-get mail_auth_pass)"
  fi
  echo "$(/native/usr/sbin/mdata-get mail_smarthost) smtp --ssl $AUTH" > /etc/exim4/passwd.client
  chmod 0640 /etc/exim4/passwd.client
  
  sed -i "s:dc_eximconfig_configtype='local':dc_eximconfig_configtype='satellite':" \
    /etc/exim4/update-exim4.conf.conf

  sed -i "s:dc_smarthost='':dc_smarthost='$(/native/usr/sbin/mdata-get mail_smarthost)':" \
    /etc/exim4/update-exim4.conf.conf
fi

sed -i "s:dc_other_hostnames='debian-8-01':dc_other_hostnames='$(/bin/echo -n `/bin/hostname -f`)':" \
  /etc/exim4/update-exim4.conf.conf

# cleanup /etc/hosts
sed -i '/ip6-allnodes/d' /etc/hosts
sed -i '/ip6-allrouter/d' /etc/hosts
sed -i '/mibe-lx-basic.qutic.net/d' /etc/hosts

hostname > /etc/mailname
service exim4 restart
