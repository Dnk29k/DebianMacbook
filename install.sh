#!/bin/bash

# --- Colores ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}
  __  __            ____             _      _    _               
 |  \/  |          |  _ \           | |    | |  | |              
 | \  / | __ _  ___| |_) | ___   ___| | __ | |  | | _ __    ___  
 | |\/| |/ _` |/ __|  _ < / _ \ / _ \ |/ / | |  | || '_ \  / _ \ 
 | |  | | (_| | (__| |_) | (_) | (_) |   <  | |__| || |_) || (_) |
 |_|  |_|\__,_|\___|____/ \___/ \___/|_|\_\  \____/ | .__/  \___/ 
                                                    | |          
                                                    |_|          
${NC}"

echo -e "${YELLOW}[*] Iniciando instalación profesional del entorno...${NC}"

# 1. Dependencias del Sistema
echo -e "${GREEN}[+] Instalando paquetes base y herramientas de sistema...${NC}"
sudo apt update
sudo apt install -y bspwm sxhkd polybar zsh neovim lsd feh kitty \
                    build-essential git awk unzip tlp mbpfan fzf picom rofi

# 2. Gestión de Hardware (MacBook)
echo -e "${GREEN}[+] Activando optimización de batería y ventiladores...${NC}"
sudo systemctl enable tlp
sudo systemctl enable mbpfan

# 3. Despliegue de Configuraciones (.config)
echo -e "${GREEN}[+] Sincronizando dotfiles desde .config/...${NC}"
mkdir -p ~/.config
# Copia todo el contenido de la carpeta .config del repo a la del sistema
cp -rf .config/* ~/.config/
cp .zshrc ~/
cp .gitconfig ~/ 2>/dev/null

# 4. Fix: Sincronización con Root
echo -e "${GREEN}[+] Vinculando entorno de Root con usuario dnk29...${NC}"
sudo ln -sf /home/dnk29/.zshrc /root/.zshrc

# 5. Fix: Symlink de BurpSuite
echo -e "${GREEN}[+] Configurando acceso global a BurpSuite...${NC}"
if [ -d "/opt/BurpSuiteCommunity" ]; then
    sudo ln -sf /opt/BurpSuiteCommunity/BurpSuiteCommunity /usr/local/bin/burpsuite
    echo -e "${GREEN}[✔] Comando 'burpsuite' habilitado.${NC}"
else
    echo -e "${YELLOW}[!] BurpSuite no detectado en /opt. Omite este paso.${NC}"
fi

# 6. Instalación de Nerd Fonts
echo -e "${GREEN}[+] Instalando Hack Nerd Font para iconos...${NC}"
if [ ! -d "$HOME/.local/share/fonts/Hack" ]; then
    mkdir -p ~/.local/share/fonts
    cd /tmp
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
    unzip -o Hack.zip -d ~/.local/share/fonts
    fc-cache -fv
    cd -
else
    echo -e "${GREEN}[✔] Fuentes ya instaladas.${NC}"
fi

# 7. Permisos de Ejecución
echo -e "${GREEN}[+] Aplicando permisos a scripts...${NC}"
chmod +x ~/.config/bspwm/scripts/*
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/bin/*

echo -e "${BLUE}[✔] ¡Instalación completada con éxito!${NC}"
echo -e "${YELLOW}[!] Reinicia la sesión para ver todos los cambios.${NC}"
