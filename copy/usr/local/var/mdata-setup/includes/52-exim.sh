#!/usr/bin/bash
IP=$(ifconfig eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
HOST=$(/native/usr/sbin/mdata-get mail_smarthost)

if /native/usr/sbin/mdata-get mail_smarthost 1>/dev/null 2>&1; then
  if /native/usr/sbin/mdata-get mail_adminaddr 1>/dev/null 2>&1; then
    echo "root: $(/native/usr/sbin/mdata-get mail_adminaddr)" >> /etc/aliases
    newaliases
  fi
  AUTH=""
  if /native/usr/sbin/mdata-get mail_auth_user 1>/dev/null 2>&1 && 
     /native/usr/sbin/mdata-get mail_auth_pass 1>/dev/null 2>&1; then
    AUTH="$(/native/usr/sbin/mdata-get mail_auth_user):$(/native/usr/sbin/mdata-get mail_auth_pass)"
  fi
  echo "$(/native/usr/sbin/mdata-get mail_smarthost):$AUTH" > /etc/exim4/passwd.client
  chmod 0640 /etc/exim4/passwd.client
  
  sed -i \
    -e "s:dc_eximconfig_configtype='local':dc_eximconfig_configtype='satellite':" \
    -e "s:dc_smarthost='':dc_smarthost='${HOST}':" \
    /etc/exim4/update-exim4.conf.conf

  # -e "s|dc_local_interfaces='127.0.0.1 ; ::1'|dc_local_interfaces='${IP}'|" \

fi

sed -i "s:dc_other_hostnames='.*':dc_other_hostnames='${HOST}':" \
  /etc/exim4/update-exim4.conf.conf

# cleanup /etc/hosts
sed -i '/ip6-allnodes/d' /etc/hosts
sed -i '/ip6-allrouter/d' /etc/hosts
sed -i '/mibe-lx-basic.qutic.net/d' /etc/hosts

/usr/sbin/update-exim4.conf

hostname > /etc/mailname
systemctl restart exim4
