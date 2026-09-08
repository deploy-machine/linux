#!/bin/sh

[ -z "$DBUS_SESSION_BUS_ADDRESS" ] && eval $(dbus-launch --exit-with-session --sh-syntax)
dbus-update-activation-environment --verbose --all
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_PID
. ~/.xprofile
exec /usr/local/bin/dwm 
