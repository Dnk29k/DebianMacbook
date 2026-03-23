#!/bin/bash

echo "🚀 Iniciando Auto-Deploy Maestro (Ecosistema Phoenix)..."

# 1. Enlaces simbólicos de Configuración (Tus rutas originales)
mkdir -p ~/.config/sxhkd ~/.config/rofi/themes ~/.config/polybar ~/bin
ln -sf ~/DebianMacbook/config/sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc
ln -sf ~/DebianMacbook/config/rofi/config.rasi ~/.config/rofi/config.rasi
cp -r ~/DebianMacbook/config/rofi/themes/* ~/.config/rofi/themes/

# Copiamos el HUD que acabamos de crear a tu carpeta personal de binarios
if [ -f "~/DebianMacbook/bin/phoenix-hud.sh" ]; then
    cp ~/DebianMacbook/bin/phoenix-hud.sh ~/bin/phoenix-hud.sh
    chmod +x ~/bin/phoenix-hud.sh
fi

# 2. Lógica Inteligente de Hardware
if grep -q "MacBookPro7,1" /sys/class/dmi/id/product_name 2>/dev/null; then
    echo "💻 Configurando entorno MacBook Pro (wlan0/enp3s0)..."
    
    # Aquí usamos directamente tu configuración de Polybar que ya tiene Nerd Fonts
    cp -r ~/DebianMacbook/config/polybar/* ~/.config/polybar/
    
    # Aplicamos el fix del driver que recordamos de sesiones anteriores
    echo "blacklist b43" | sudo tee /etc/modprobe.d/b43-blacklist.conf > /dev/null

else
    echo "🖥️ Configurando entorno MV / Desktop (Ethernet/Burp)..."
    
    # En la MV, copiamos la configuración pero ajustamos la interfaz al vuelo
    # Esto evita que tengas que tener dos archivos .ini
    cp -r ~/DebianMacbook/config/polybar/* ~/.config/polybar/
    sed -i 's/wlan0/ens33/g' ~/.config/polybar/config.ini 2>/dev/null
    
    # Fix de BurpSuite que ya conocemos
    if [ -d "/opt/BurpSuiteCommunity" ]; then
        sudo ln -sf /opt/BurpSuiteCommunity/BurpSuiteCommunity /usr/local/bin/burpsuite
        echo "✅ Symlink de BurpSuite creado."
    fi
fi

# 3. Reiniciar servicios
pkill -USR1 -x sxhkd
polybar-msg cmd restart 2>/dev/null

echo "✨ ¡Ecosistema actualizado sin romper nada!"
