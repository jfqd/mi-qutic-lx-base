#!/usr/bin/bash

if /usr/sbin/mdata-get vfstab 1>/dev/null 2>&1; then
  VFSTAB=$(mdata-get vfstab)
  # extend vfstab
  /usr/bin/cat >> /etc/fstab << EOF
$VFSTAB
EOF
  # mount directory
  # TODO: handle multiple lines
  MOUNTPOINT=$(/usr/bin/echo "$VFSTAB" | /usr/bin/awk '{print $3}')
  if [ -n "$MOUNTPOINT" ]; then
    /usr/bin/mkdir -p "$MOUNTPOINT"
    /usr/bin/mount "$MOUNTPOINT" || true
  fi
fi
