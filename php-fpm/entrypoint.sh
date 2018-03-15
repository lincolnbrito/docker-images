#!/bin/bash

UNAMEOUT="$(uname -s)"
case "${UNAMEOUT}" in
    Linux*)             MACHINE=linux;;
    Darwin*)            MACHINE=mac;;
    MINGW64_NT-10.0*)   MACHINE=mingw64;;
    *)                  MACHINE="UNKNOWN"
esac

if [ "$MACHINE" == "UNKNOWN" ]; then
    echo "Unsupported system type"
    echo "System must be a Macintosh, Linux or Windows"
    echo ""
    echo "System detection determined via uname command"
    echo "If the following is empty, could not find uname command: $(which uname)"
    echo "Your reported uname is: $(uname -s)"
fi

# Set environment variables for dev
if [ "$MACHINE" == "linux" ]; then
    if grep -q Microsoft /proc/version; then # WSL
        export XDEBUG_HOST=10.0.75.1
    else
        if [ "$(command -v ip)" ]; then
            export XDEBUG_HOST=$(ip addr show docker0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
        else
            export XDEBUG_HOST=$(ifconfig docker0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)
        fi
    fi
    SEDCMD="sed -i"
elif [ "$MACHINE" == "mac" ]; then
    export XDEBUG_HOST=$(ipconfig getifaddr en0) # Ethernet

    if [ -z "$XDEBUG_HOST" ]; then
        export XDEBUG_HOST=$(ipconfig getifaddr en1) # Wifi
    fi
    SEDCMD="sed -i .bak"
elif [ "$MACHINE" == "mingw64" ]; then # Git Bash
    export XDEBUG_HOST=10.0.75.1
    SEDCMD="sed -i"
fi

export WWWUSER=${WWWUSER:-$UID}

# Config /etc/php/7.2/mods-available/xdebug.ini
sed -i "s/xdebug\.remote_host\=.*/xdebug\.remote_host\=$XDEBUG_HOST/g" /etc/php/7.2/mods-available/xdebug.ini

# Run PHP-FPM as current user
if [ ! -z "$WWWUSER" ]; then
    sed -i "s/user\ \=.*/user\ \= $WWWUSER/g" /etc/php/7.2/fpm/pool.d/www.conf

    # Set UID of user "vessel"
    usermod -u $WWWUSER vessel
fi

# Ensure /.composer exists and is writable
if [ ! -d /.composer ]; then
    mkdir /.composer
fi
chmod -R ugo+rw /.composer

# Run a command or supervisord
if [ $# -gt 0 ];then
    # If we passed a command, run it as current user
    exec gosu $WWWUSER "$@"
else
    # Otherwise start supervisord
    /usr/bin/supervisord
fi