#!/usr/bin/bash

if /usr/sbin/mdata-get ipv6_route 1>/dev/null 2>&1; then
  IPROUTE=$(mdata-get ipv6_route)
  /native/sbin/route -p add -inet6 default "${IPROUTE}"
  /usr/bin/netstat -6nr
fi