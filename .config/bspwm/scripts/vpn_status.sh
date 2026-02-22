#!/bin/sh
# Prioridad: HTB (tun0) > NordVPN (nordlynx) > Off
IFACE_HTB=$(/usr/sbin/ip addr show tun0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
IFACE_NORD=$(/usr/sbin/ip addr show nordlynx 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

if [ "$IFACE_HTB" != "" ]; then
    echo "%{F#ffb86c}󰆧 %{F#ffffff}HTB: $IFACE_HTB"
elif [ "$IFACE_NORD" != "" ]; then
    echo "%{F#8be9fd}󰖂 %{F#ffffff}Nord: $IFACE_NORD"
else
    echo "%{F#6272a4}󰖂 %{F#6272a4}VPN Off"
fi
