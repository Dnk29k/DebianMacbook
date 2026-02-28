cat << 'EOF' > ~/DebianMacbook/scripts/setup_env.sh
#!/bin/bash

echo "🚀 Iniciando Auto-Deploy Maestro para Macbook-Debian..."

# 1. Enlaces simbólicos de Configuración
mkdir -p ~/.config/sxhkd ~/.config/rofi/themes ~/.config/polybar
ln -sf ~/DebianMacbook/config/sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc
ln -sf ~/DebianMacbook/config/rofi/config.rasi ~/.config/rofi/config.rasi
cp -r ~/DebianMacbook/config/rofi/themes/* ~/.config/rofi/themes/
cp -r ~/DebianMacbook/config/polybar/* ~/.config/polybar/

# 2. Fix de BurpSuite (Symlink)
if [ -d "/opt/BurpSuiteCommunity" ]; then
    sudo ln -sf /opt/BurpSuiteCommunity/BurpSuiteCommunity /usr/local/bin/burpsuite
    echo "✅ Symlink de BurpSuite creado."
fi

# 3. Reiniciar servicios
pkill -USR1 -x sxhkd
polybar-msg cmd restart 2>/dev/null

echo "✨ ¡Todo configurado y optimizado!"
