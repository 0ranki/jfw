# jfw
iptables control system

##### What is it?
This is my take on replacing the rc.local -method of configuring `iptables` at
startup.

##### How to install?
Clone the repo and make `install.bash` and `jfw.rules` executable, then run
`install.bash` as root.

When you run `install.bash`, the script copies the file `jfw.rules` to
`/etc/jfw/`, makes a symlink to it in `/usr/sbin` and copies the included
`jfw.service` systemd service file to `/etc/systemd/system/`.

You have the option to enable & start the service right away or do it later
yourself using systemctl.

`jfw.rules` is basically just a list of iptables commands, with a couple of
predefined parameters. The systemd service runs the script at startup.

Outbound traffic, inbound MDNS and inbound SSH are allowed by default.

##### How to uninstall?
If you haven't already, clone the repo, make `uninstall.bash`executable`
and run `uninstall.bash`.

##### Why use this?
The traditional method of using `/etc/rc.local` to run your init scripts
is deprecated by many distros. This is just another way to configure iptables.

There are a couple of handy parameters to the `jfw` command:
- `jfw flush` flushes the rules and disables the firewall
- `jfw edit` is an alias to edit `/etc/jfw/jfw.rules` with your defined $EDITOR
- `jfw logs` greps `dmesg` to show the logs
- `jfw list` shows the currently active `iptables` rules for IPv4 and IPv6
- `jfw test` applies your ruleset and automatically flushes the rules after
  60 seconds. Just remember to use `nohup`, `screen` or `tmux` so the script
  will continue running even if your connection breaks.
- `jfw reload` resets the rules to those defined in `/etc/jfw/jfw.rules`
  This is useful when modifying the rules remotely so you don't get locked out.

##### Why not use this?
If you are unsure about the methods I've used, don't use these scripts. 
Ask someone if it is safe to use them.
If you have no idea how to use `iptables`, then this might not be the easiest
way to control the Linux firewall. My personal favourite of the more
comprehensive firewall programs is `firewalld`.
