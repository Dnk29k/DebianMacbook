#!/bin/bash

# --- Definición de Colores ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- Banner de Inicio ---
clear
echo -e "${BLUE}"
cat << "EOF"
  __  __            ____             _      _    _               
 |  \/  |          |  _ \           | |    | |  | |              
 | \  / | __ _  ___| |_) | ___   ___| | __ | |  | | _ __    ___  
 | |\/| |/ _` |/ __|  _ < / _ \ / _ \ |/ / | |  | || '_ \  / _ \ 
 | |  | | (_| | (__| |_) | (_) | (_) |   <  | |__| || |_) || (_) |
 |_|  |_|\__,_|\___|____/ \___/ \___/|_|\_\  \____/ | .__/  \___/ 
                                                    | |          
                                                    |_|          
EOF
echo -e "${NC}"
echo -e "${YELLOW}[*] Iniciando despliegue del ecosistema MacBook-Debian...${NC}"

# 1. Comprobación de privilegios
if [ "$EUID" -eq 0 ]; then 
    echo -e "${RED}[!] No ejecutes este script como root (usa sudo dentro del script)${NC}"
    exit 1
fi

# 2. Instalación de Dependencias Críticas
echo -e "${GREEN}[+] Actualizando repositorios e instalando herramientas...${NC}"
sudo apt update
sudo apt install -y bspwm sxhkd polybar zsh neovim lsd feh kitty \
                    build-essential git awk unzip tlp mbpfan fzf picom rofi \
                    libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-image0-dev \
                    libxcb-randr0-dev libxcb-util0-dev libxcb-keysyms1-dev \
                    libxcb-shape0-dev

# 3. Optimización de Hardware MacBook
echo -e "${GREEN}[+] Configurando gestión térmica y de batería...${NC}"
sudo systemctl enable tlp
sudo systemctl enable mbpfan

# 4. Despliegue de Configuraciones (.config)
echo -e "${GREEN}[+] Sincronizando dotfiles desde el repositorio...${NC}"
mkdir -p ~/.config

# Copia masiva de carpetas de configuración
if [ -d ".config" ]; then
    cp -rf .config/* ~/.config/
    echo -e "${GREEN}[✔] Carpetas de configuración sincronizadas.${NC}"
else
    echo -e "${RED}[!] Error: No se encuentra la carpeta .config en el repo.${NC}"
fi

# Copia de archivos de usuario
cp .zshrc ~/ 2>/dev/null
cp .gitconfig ~/ 2>/dev/null

# 5. Persistencia de Configuración para Root
echo -e "${GREEN}[+] Enlazando configuración de Zsh para el usuario Root...${NC}"
sudo ln -sf /home/$(whoami)/.zshrc /root/.zshrc

# 6. Fix de Burp Suite
echo -e "${GREEN}[+] Verificando instalación de Burp Suite...${NC}"
BURP_PATH="/opt/BurpSuiteCommunity/BurpSuiteCommunity"
if [ -f "$BURP_PATH" ]; then
    sudo ln -sf "$BURP_PATH" /usr/local/bin/burpsuite
    echo -e "${GREEN}[✔] Simlink de Burp Suite creado.${NC}"
else
    echo -e "${YELLOW}[!] Burp Suite no encontrado en $BURP_PATH. Instálalo manualmente.${NC}"
fi

# 7. Instalación Automática de Nerd Fonts (Hack)
echo -e "${GREEN}[+] Configurando tipografía e iconos (Nerd Fonts)...${NC}"
FONT_DIR="$HOME/.local/share/fonts/Hack"
if [ ! -d "$FONT_DIR" ]; then
    mkdir -p ~/.local/share/fonts
    wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip -O /tmp/Hack.zip
    unzip -oq /tmp/Hack.zip -d ~/.local/share/fonts
    fc-cache -fv > /dev/null
    echo -e "${GREEN}[✔] Nerd Fonts instaladas.${NC}"
else
    echo -e "${GREEN}[✔] Nerd Fonts ya presentes en el sistema.${NC}"
fi

# 8. Ajuste de Permisos de Ejecución
echo -e "${GREEN}[+] Otorgando permisos de ejecución a los scripts...${NC}"
chmod +x ~/.config/bspwm/scripts/* 2>/dev/null
chmod +x ~/.config/polybar/launch.sh 2>/dev/null
chmod +x ~/.config/bin/* 2>/dev/null

# --- Finalización ---
echo -e "${BLUE}--------------------------------------------------${NC}"
echo -e "${GREEN}[✔] ¡Entorno configurado con éxito!${NC}"
echo -e "${YELLOW}[!] Por favor, cierra sesión y vuelve a entrar.${NC}"
echo -e "${BLUE}--------------------------------------------------${NC}"
