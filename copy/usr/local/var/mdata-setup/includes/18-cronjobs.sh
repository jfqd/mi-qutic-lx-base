#!/usr/bin/bash

if [[ ! -f /etc/cron.d/systemd_health_check ]]; then

cat > /etc/cron.d/systemd_health_check << EOF
MAILTO=root
#
*/2 * * * *     root   /usr/local/bin/systemd_health_check
# END
EOF

fi