#!/usr/bin/bash

HOSTNAME=$(/usr/bin/hostname)
sed -i \
    "s/host.example.com/${HOSTNAME}/" \
    /etc/filebeat/filebeat.yml

if mdata-get logstash_redis 1>/dev/null 2>&1; then
  LOGSTASH_REDIS=$(mdata-get logstash_redis | sed "s/,/\",\"/")

  sed -i \
      "s#127.0.0.1#${LOGSTASH_REDIS}#" \
      /etc/filebeat/filebeat.yml
fi

systemctl start filebeat
systemctl enable filebeat
