#!/bin/bash

# Importar el UUID desde el archivo local (que no está en GitHub)
source $(dirname "$0")/.key_data

if ! lsblk -no UUID | grep -q "$KEY_UUID"; then
    echo "🚨 LLAVE NO ENCONTRADA."
    sleep 2
    /sbin/poweroff
fi
