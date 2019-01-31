#!/bin/bash

if /native/usr/sbin/mdata-get sdc:hostname 1>/dev/null 2>&1; then
  HOSTNAME=$(/native/usr/sbin/mdata-get sdc:hostname)
  hostname $HOSTNAME
  hostname > /etc/hostname
  tail -n +2 /etc/hosts > /etc/hosts.bak
  echo "127.0.0.1       ${HOSTNAME}" >> /etc/hosts.bak
  rm /etc/hosts
  mv /etc/hosts.bak /etc/hosts
  # echo "search $(hostname -d)">> /etc/resolv.conf
fi