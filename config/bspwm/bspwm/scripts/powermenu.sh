#!/bin/bash

# Usando rofi si lo tienes instalado, o un menú sencillo de bspwm
options=" Apagar\n Reiniciar\n Suspender\n󰈆 Cerrar Sesión"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Sistema:" -theme-str 'window {width: 200px;}')

case $chosen in
    " Apagar") sudo poweroff ;;
    " Reiniciar") sudo reboot ;;
    " Suspender") systemctl suspend ;;
    "󰈆 Cerrar Sesión") bspc quit ;;
esac
