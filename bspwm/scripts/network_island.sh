#!/bin/bash

# Interfaces (Confirmadas para tu MacBook-Debian)
ETHERNET="enp3s0"
WIFI="wlan0"

# Colores (Limpios sin espacios residuales)
COLOR_ETH="%{F#9ece6a}"
COLOR_WIFI="%{F#2ac3de}"
COLOR_DISC="%{F#f7768e}"
RESET="%{F-}"

# 1. Comprobar Ethernet
ip_eth=$(ip -o -4 addr show $ETHERNET 2>/dev/null | awk '{print $4}' | cut -d/ -f1)

if [ -n "$ip_eth" ]; then
    echo "${COLOR_ETH}󰈀 %{F#ffffff}$ip_eth${RESET}"
    exit 0
fi

# 2. Comprobar WiFi
ip_wifi=$(ip -o -4 addr show $WIFI 2>/dev/null | awk '{print $4}' | cut -d/ -f1)

if [ -n "$ip_wifi" ]; then
    echo "${COLOR_WIFI}󰖩 %{F#ffffff}$ip_wifi${RESET}"
    exit 0
fi

# 3. Desconectado
echo "${COLOR_DISC}󰤮 ${RESET}Offline${RESET}"
