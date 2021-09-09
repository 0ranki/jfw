#!/bin/bash -e

# root check
if [[ "$UID" -ne 0 ]]; then
    echo "This script needs root permissions."
    exit 1
fi

RULES_FILE='/etc/jfw/jfw.rules'

# Make /etc/jfw directory with "rules" file
# (which is really the iptables script)
if [[ -f $RULES_FILE ]]; then
    echo "Found existing jfw configuration, do you wish to overwrite (y/n)?"
    read -n 1
    if [[ "$REPLY" == "y" ]];then
        echo "Overwriting '$RULES_FILE'"
        cp jfw.rules /etc/jfw/
        chmod -R 700 /etc/jfw
    else
        echo "Not overwriting '$RULES_FILE' ."
    fi
else
    mkdir -p /etc/jfw
    cp jfw.rules /etc/jfw/
    chmod -R 700 /etc/jfw
fi

# Copy executable in place:
cp jfw /usr/local/sbin/jfw
chown root:wheel /usr/local/sbin/jfw
chmod 750 /usr/local/sbin/jfw

# Install systemd service file,
cp jfw.service /etc/systemd/system
systemctl daemon-reload

echo "SSH port (22) is opened by default with JFW."
read -p "Enable & start JFW now (yes/no)? "

if [[ "$REPLY" == "yes" ]]; then
    systemctl enable --now jfw
else
    echo "You can edit the iptables rules to your liking by editing"
    echo "'$RULES_FILE'. Afterwards you can use systemct to start"
    echo "and/or enable the firewall."
fi
