#!/bin/sh

touch /home/xray/.Xauthority
chown xray:xray /home/xray/.Xauthority
uuidgen > /etc/machine-id

echo "export QT_XKB_CONFIG_ROOT=/usr/share/X11/locale"   >> /etc/profile
echo "[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/motd" >> /etc/profile

source /etc/profile

exec "$@"
