#!/bin/bash

# root check
if [[ "$UID" -ne 0 ]]; then
    echo "This script needs root permissions."
    exit 1
fi

# Make /etc/jfw directory with "rules" file
# (which is really the iptables script)
if [[ -f /etc/jfw/jfw.rules ]]; then
    echo "Found existing jfw configuration, do you wish to overwrite (y/n)?"
    read -n 1
    if [[ "$REPLY" == "y" ]];then
        echo "Overwriting '/etc/jfw/jfw.rules'"
        cp jfw.rules /etc/jfw/
        chmod -R 700 /etc/jfw
    else
        echo "Not overwriting '/etc/jfw/jfw.rules' ."
    fi
else
    mkdir -p /etc/jfw
    cp jfw.rules /etc/jfw/
    chmod -R 700 /etc/jfw
fi

# Create symlink to jfw.rules:
ln -s /etc/jfw/jfw.rules /usr/sbin/jfw

# Install systemd service file,
# Still needs to be enabled automatically
cp jfw.service /etc/systemd/system
systemctl daemon-reload

echo "SSH port (22) is opened by default with JFW."
read -p "Enable & start JFW now (yes/no)? "

if [[ "$REPLY" == "yes" ]]; then
    systemctl enable --now jfw
else
    echo "You can edit the iptables rules to your liking by editing"
    echo "'/etc/jfw/jfw.rules'. Afterwards you can use systemct to start"
    echo "and/or enable the firewall."
fi
