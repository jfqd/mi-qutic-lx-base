#!/usr/bin/bash

# cleanup /etc/hosts
sed -i '/ip6-allnodes/d' /etc/hosts
sed -i '/ip6-allrouter/d' /etc/hosts
sed -i '/mibe-lx-basic.qutic.net/d' /etc/hosts

HOSTNAME=$(hostname)
RELAYHOST="$(/native/usr/sbin/mdata-get mail_smarthost)"
USERNAME="$(/native/usr/sbin/mdata-get mail_auth_user)"
PASSWORD="$(/native/usr/sbin/mdata-get mail_auth_pass)"

hostname > /etc/mailname

# /var/cache/debconf/config.dat
echo "postfix postfix/main_mailer_type select smarthost" | debconf-set-selections 
echo "postfix postfix/mailname string ${HOSTNAME}" | debconf-set-selections 
# echo "postfix postfix/relayhost string smtp.localdomain" | debconf-set-selections

cat > /etc/postfix/main.cf << EOF
# See /usr/share/postfix/main.cf.dist for a commented, more complete version

# Debian specific:  Specifying a file name will cause the first
# line of that file to be used as the name.  The Debian default
# is /etc/mailname.
myorigin = /etc/mailname
myhostname = $(hostname)

smtpd_banner = \$myhostname ESMTP \$mail_name (Ubuntu)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
delay_warning_time = 4h

readme_directory = no

compatibility_level = 3.4

# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_tls_security_level=may

smtp_tls_CApath=/etc/ssl/certs
#smtp_tls_security_level=may
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

masquerade_domains = qutic.net

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
mydestination = $(hostname), localhost.qutic.net, localhost
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_protocols = ipv4

smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_security_level = encrypt
relayhost = ${RELAYHOST}:587
# smtp_use_tls = yes
inet_interfaces = 127.0.0.1
EOF

cat > /etc/postfix/sasl_passwd << EOF
${RELAYHOST} ${USERNAME}:${PASSWORD}
EOF
chmod 0600 /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd

systemctl enable postfix
systemctl start postfix
systemctl status postfix
