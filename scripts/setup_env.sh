#!/bin/bash

echo "🚀 Iniciando Auto-Deploy para Macbook-Debian..."

# 1. Instalar dependencias necesarias
sudo apt update
sudo apt install -y rofi sxhkd i3lock-fancy xautolock

# 2. Crear carpetas de configuración si no existen
mkdir -p ~/.config/rofi/themes
mkdir -p ~/.config/sxhkd

# 3. Crear Enlaces Simbólicos (Vincular Repo con Sistema)
echo "🔗 Vinculando archivos de configuración..."
ln -sf ~/DebianMacbook/config/sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc
ln -sf ~/DebianMacbook/config/rofi/config.rasi ~/.config/rofi/config.rasi

# 4. Copiar temas de Rofi
cp -r ~/DebianMacbook/config/rofi/themes/* ~/.config/rofi/themes/

# 5. Reiniciar sxhkd para aplicar cambios
pkill -USR1 -x sxhkd

echo "✅ ¡Configuración completada con éxito!"
