#!/usr/bin/bash

# Configure nrpe allowed connections
if mdata-get nagios_allow 1>/dev/null 2>&1; then
  sed -i \
       "s/allowed_hosts=127.0.0.1,::1/allowed_hosts=$(mdata-get nagios_allow)/" \
       /opt/local/etc/nagios/nrpe.cfg
  systemctl restart nagios-nrpe-server
fi
