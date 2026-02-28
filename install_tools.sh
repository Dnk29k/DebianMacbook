#!/bin/bash

# 🛡️ Script de configuración de herramientas - DebianMacbook
echo "🔧 Configurando Burp Suite..."

# Crear symlink si existe el binario pero no el comando
if [ -f /opt/BurpSuiteCommunity/BurpSuiteCommunity ] && [ ! -L /usr/local/bin/burpsuite ]; then
    sudo ln -s /opt/BurpSuiteCommunity/BurpSuiteCommunity /usr/local/bin/burpsuite
    echo "✅ Symlink de Burp Suite creado en /usr/local/bin/burpsuite"
else
    echo "ℹ️ Burp Suite ya está configurado o no se encuentra en /opt"
fi

# Aquí añadiremos más herramientas en el futuro
sudo mkdir -p /root/.config && sudo ln -sf /home/dnk29/.config/nvim /root/.config/nvim
