#!/bin/sh
# Configurado para tu interfaz enp3s0
IFACE=$(/usr/sbin/ip addr show enp3s0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

if [ "$IFACE" != "" ]; then
    echo "%{F#2498e3}󰈀 %{F#ffffff}$IFACE"
else
    echo "%{F#ff5555}󰈂 %{F#666}Disconnected"
fi
