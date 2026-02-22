#!/bin/bash

# Comprobar si bluetoothctl está instalado
if ! command -v bluetoothctl &> /dev/null; then
    echo ""
    exit 0
fi

# Verificar si el controlador está encendido
if bluetoothctl show | grep -q "Powered: yes"; then
    # Verificar si hay algún dispositivo conectado
    if bluetoothctl info | grep -q "Device"; then
        # Icono Cian Eléctrico (Conectado) 
        echo "%{F#2ac3de}%{F-}"
    else
        # Icono verde (Encendido pero libre)
        echo "%{F#a6e22e}%{F-}"
    fi
else
    echo "" # Apagado
fi
