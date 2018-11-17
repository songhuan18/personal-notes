#!/bin/sh
if [ $PASSWORD ]; then
    sed -i "s/your_password/${PASSWORD}/g" /etc/shadowsocks.json
fi
ssserver -c /etc/shadowsocks.json -d start
tail -f /var/log/shadowsocks.log
