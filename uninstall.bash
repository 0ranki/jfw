#!/bin/bash -e

if [[ "$UID" -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

echo "This will uninstall the jfw executable, systemd service and flush"
echo "your iptables & ip6tables rules."
read -n 1 -p "Proceed with uninstallation (y/n)? "

if [[ $REPLY == "y" ]]; then
    unset $REPLY
    printf "\n"
    jfw flush
    systemctl disable --now jfw.service
    rm -f /etc/systemd/system/jfw.service
    systemctl daemon-reload
    rm -f /usr/sbin/jfw
    
    read -n 1 -p "Remove '/etc/jfw/jfw.rules' (y/n)? "
    printf "\n"
    [[ "$REPLY" == "y" ]] && rm -rf /etc/jfw
    [[ "$REPLY" != "y" ]] && echo "Keeping '/etc/jfw/jfw.rules'"

    echo "JFW succesfully removed!"
    exit 0

else
    echo "Aborting uninstallation."
    exit 1
fi
    
