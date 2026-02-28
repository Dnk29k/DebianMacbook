#!/usr/bin/env bash

# 1. Matar cualquier instancia previa de Polybar
killall -q polybar

# 2. Esperar a que los procesos se hayan cerrado completamente
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# 3. Lanzar la barra "main" usando el archivo current.ini
# No necesitas cargar 'log', 'top' o 'ethernet_bar' por separado, 
# ya que ahora todo está dentro de 'main'.
polybar -c ~/.config/polybar/current.ini main &
polybar target_to_hack -c ~/.config/polybar/current.ini &
echo "Polybar (Arquitectura de Islas) lanzada..."
