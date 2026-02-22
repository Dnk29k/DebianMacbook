#!/bin/bash

# 🛡️ VPN Killswitch Táctico - DebianMacbook Edition
if [ "$EUID" -ne 0 ]; then
  echo "🚨 Por favor, ejecuta como root (sudo)"
  exit
fi

# Detectar la subred local automáticamente (para no bloquear el acceso al router)
LOCAL_NET=$(ip route | grep eth0 -m 1 | awk '{print $1}')
[ -z "$LOCAL_NET" ] && LOCAL_NET=$(ip route | grep wlan0 -m 1 | awk '{print $1}')

if [ "$1" == "on" ]; then
    echo "🔒 [OPSEC] Confinando tráfico a la interfaz tun0..."
    
    # Resetear reglas y bloquear todo por defecto
    ufw --force reset
    ufw default deny incoming
    ufw default deny outgoing
    
    # Permitir DNS para resolución de nombres
    ufw allow out 53
    # Permitir tráfico por el túnel VPN
    ufw allow out on tun0 from any to any
    ufw allow in on tun0 from any to any
    # Permitir la conexión de OpenVPN (Puerto estándar 1194 UDP)
    ufw allow out 1194/udp
    
    # Permitir tráfico en tu red local si se detectó
    if [ ! -z "$LOCAL_NET" ]; then
        ufw allow out to $LOCAL_NET
        ufw allow in from $LOCAL_NET
    fi
    
    ufw --force enable
    echo "✅ Killswitch ACTIVADO. Solo puedes navegar a través de la VPN (tun0)."

elif [ "$1" == "off" ]; then
    echo "🔓 [OPSEC] Desactivando Killswitch..."
    ufw --force reset
    ufw default allow outgoing
    ufw default allow incoming
    ufw disable
    echo "✅ Tráfico normal restaurado."
else
    echo "Uso: sudo vpn_lock.sh [on|off]"
fi
