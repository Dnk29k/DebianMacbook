#!/bin/bash
while true; do
    cap=$(cat /sys/class/power_supply/BAT0/capacity)
    stat=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$cap" -le 5 ] && [ "$stat" = "Discharging" ]; then
        notify-send -u critical "🚨 BATERÍA CRÍTICA: $cap%" "El sistema se apagará pronto. ¡CONECTA EL CARGADOR!"
    elif [ "$cap" -le 15 ] && [ "$stat" = "Discharging" ]; then
        notify-send -u normal "⚠️ Batería Baja: $cap%" "Busca el cargador MagSafe."
    fi
    sleep 60
done
