#!/bin/bash
# Configure munin-node allowed connections

MUNIN_CONF='/etc/munin/munin-node.conf'

if /native/usr/sbin/mdata-get munin_master_allow 1>/dev/null 2>&1; then
  echo "# mdata-get munin_master_allow" >> ${MUNIN_CONF}
  for allow in $(/native/usr/sbin/mdata-get munin_master_allow); do
    echo "allow ^${allow//\./\\.}$" >> ${MUNIN_CONF}
  done
  service munin-node restart
fi
