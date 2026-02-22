#!/bin/bash

TARGET_FILE="/home/dnk29/.config/bin/target"
[ ! -f "$TARGET_FILE" ] && touch "$TARGET_FILE" 2>/dev/null

ip_address=$(awk '{print $1}' "$TARGET_FILE" 2>/dev/null)
machine_name=$(awk '{print $2}' "$TARGET_FILE" 2>/dev/null)

if [ "$ip_address" ] && [ "$machine_name" ]; then
    # Icono Rojo Neón y texto Blanco para que la IP resalte sobre el rojo
	echo "%{T2}%{F#ff5555}󰓾 %{F#ffffff}$ip_address%{F-} - %{F#ff5555}$machine_name%{F-}%{T-}"
else
    # TODO EN ROJO cuando no hay nada
    echo "%{F#ff5555}󰓾 %{F#ffffff}No target%{F-}"
fi
