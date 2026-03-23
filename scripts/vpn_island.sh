#!/bin/bash

# Colores (Limpios y sin espacios residuales)
COLOR_HTB="%{F#9ece6a}"
COLOR_NORD="%{F#7dcfff}"
COLOR_OFF="%{F#565f89}"
RESET="%{F-}"

# 1. Detectar Hack The Box (tun0)
ip_htb=$(ip -o -4 addr show tun0 2>/dev/null | awk '{print $4}' | cut -d/ -f1)

if [ -n "$ip_htb" ]; then
    echo "${COLOR_HTB}󰆧 ${RESET}HTB: $ip_htb${RESET}"
    exit 0
fi

# 2. Detectar NordVPN (nordlynx o tun1)
ip_nord=$(ip -o -4 addr show nordlynx 2>/dev/null | awk '{print $4}' | cut -d/ -f1)
if [ -z "$ip_nord" ]; then
    ip_nord=$(ip -o -4 addr show tun1 2>/dev/null | awk '{print $4}' | cut -d/ -f1)
fi

if [ -n "$ip_nord" ]; then
    echo "${COLOR_NORD} ${RESET}Nord: $ip_nord${RESET}"
    exit 0
fi

# 3. Desconectado
echo "%{F#2ac3de}󰆧 %{F#ffffff}Disconnected${RESET}"
