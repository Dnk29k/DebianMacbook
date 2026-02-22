#!/bin/bash

# --- Colores para la terminal ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[*] Iniciando instalación automática del entorno MacBook-Debian...${NC}"

# 1. Actualización del sistema
echo -e "${GREEN}[+] Actualizando repositorios...${NC}"
sudo apt update && sudo apt upgrade -y

# 2. Instalación de dependencias críticas
echo -e "${GREEN}[+] Instalando paquetes necesarios...${NC}"
sudo apt install -y bspwm sxhkd polybar zsh neovim lsd feh kitty build-essential git awk

# 3. Despliegue de configuraciones (Dotfiles)
echo -e "${GREEN}[+] Copiando archivos de configuración...${NC}"
mkdir -p ~/.config
cp -r bspwm ~/.config/
cp -r sxhkd ~/.config/
cp -r polybar ~/.config/
cp .zshrc ~/

# 4. Fix: Sincronización de Zsh con Root
echo -e "${GREEN}[+] Vinculando .zshrc de root con usuario dnk29...${NC}"
sudo ln -sf /home/dnk29/.zshrc /root/.zshrc

# 5. Fix: Symlink de BurpSuite
echo -e "${GREEN}[+] Configurando acceso directo para BurpSuite...${NC}"
if [ -f "/opt/BurpSuiteCommunity/BurpSuiteCommunity" ]; then
    sudo ln -sf /opt/BurpSuiteCommunity/BurpSuiteCommunity /usr/local/bin/burpsuite
    echo -e "${GREEN}[✔] Symlink de BurpSuite creado.${NC}"
else
    echo -e "${YELLOW}[!] BurpSuite no encontrado en /opt, omitiendo symlink...${NC}"
fi

# 6. Permisos de Scripts
echo -e "${GREEN}[+] Aplicando permisos de ejecución a los scripts...${NC}"
chmod +x ~/.config/bspwm/scripts/*
chmod +x ~/.config/polybar/launch.sh

# 7. Finalización
echo -e "${YELLOW}[*] Instalación completada. Reinicia bspwm o la terminal.${NC}"
