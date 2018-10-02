#!/bin/bash
if mdata-get mail_smarthost 1>/dev/null 2>&1; then
	if mdata-get mail_adminaddr 1>/dev/null 2>&1; then
		echo "root: $(mdata-get mail_adminaddr)" >> /etc/aliases
	fi
	AUTH=""
	if mdata-get mail_auth_user 1>/dev/null 2>&1 && 
	   mdata-get mail_auth_pass 1>/dev/null 2>&1; then
		AUTH="--user=$(mdata-get mail_auth_user) --pass=$(mdata-get mail_auth_pass)"
	fi
	echo "$(mdata-get mail_smarthost) smtp --ssl $AUTH" > /etc/exim4/passwd.client
	chmod 0640 /etc/exim4/passwd.client
  
  sed -i "s:dc_eximconfig_configtype='local':dc_eximconfig_configtype='satellite':" \
    /etc/exim4/update-exim4.conf.conf

  sed -i "s:dc_smarthost='':dc_smarthost='$(mdata-get mail_smarthost)':" \
    /etc/exim4/update-exim4.conf.conf
fi
