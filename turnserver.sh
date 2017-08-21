#!/bin/bash

CONFIG=/usr/local/etc/turnserver.conf

if [ -z $SKIP_AUTO_IP ] && [ -z $EXTERNAL_IP ]
then
    if [ ! -z $USE_IPV4 ]
    then
        EXTERNAL_IP=`curl -4 icanhazip.com 2> /dev/null`
    else
        EXTERNAL_IP=`curl icanhazip.com 2> /dev/null`
    fi
fi

if [ -z $PORT ]
then
    PORT=3478
fi

if [ ! -e /tmp/turnserver.configured ]
then
    if [ -z $SKIP_AUTO_IP ]
    then
        echo external-ip=$EXTERNAL_IP > $CONFIG
    fi
    echo listening-port=$PORT >> $CONFIG

    if [ ! -z $LISTEN_ON_PUBLIC_IP ]
    then
        echo listening-ip=$EXTERNAL_IP >> $CONFIG
    fi

    touch /tmp/turnserver.configured
fi

echo realm=lokkhi.io >> $CONFIG
echo verbose >> $CONFIG
echo fingerprint >> $CONFIG
echo lt-cred-mech >> $CONFIG

exec /usr/local/bin/turnserver --no-cli >> /var/log/turnserver.log 2>&1
