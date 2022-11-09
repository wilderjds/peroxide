#!/bin/bash

cp cmd/peroxide/peroxide /usr/sbin
cp cmd/peroxide-cfg/peroxide-cfg /usr/sbin

set +e

getent group peroxide >/dev/null 2>&1
if [ $? != 0 ]; then
    groupadd -r peroxide
fi

GRP=""
getent group www-data >/dev/null 2>&1
if [ $? == 0 ]; then
    GRP="-G www-data"
fi

getent passwd peroxide >/dev/null 2>&1
if [ "$?" != "0" ]; then
    useradd --system --no-create-home -g peroxide $GRP peroxide
fi

set -e

if [ ! -d /var/cache/peroxide ]; then
    mkdir /var/cache/peroxide
    chown peroxide:peroxide /var/cache/peroxide
    chmod 700 /var/cache/peroxide
fi

if [ ! -f /etc/peroxide.conf ]; then
    cp config.example.yaml /etc/peroxide.conf
fi

if [ ! -d /etc/peroxide ]; then
    mkdir /etc/peroxide
    chown peroxide:peroxide /etc/peroxide
    chmod 700 /etc/peroxide
fi

#if [ ! -f /etc/systemd/system/peroxide.service ]; then
#    cp peroxide.service /etc/systemd/system/peroxide.service
#    systemctl daemon-reload
#fi

if [ ! -d /var/log/peroxide ]; then
    mkdir /var/log/peroxide
    chown peroxide:peroxide /var/log/peroxide
    chmod 750 /var/log/peroxide
fi

if [ -d /etc/logrotate.d ] && [ ! -f /etc/logrotate.d/peroxide ]; then
    cp peroxide.logrotate /etc/logrotate.d/peroxide
    # systemctl restart logrotate
fi
