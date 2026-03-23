#!/bin/bash

# --- Definición de Colores ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# --- Detectar Usuario Real (Incluso con sudo) ---
REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

# --- Banner de Inicio ---
clear
echo -e "${BLUE}"
# El EOF debe estar solo en su propia línea al final del bloque
cat << "EOF"
  __  __            ____             _      _    _ 
 |  \/  |          |  _ \           | |    | |  | |
 | \  / | __ _  ___| |_) | ___  ___| | __ | |  | | _ __   ___ 
 | |\/| |/ _` |/ __|  _ < / _ \ / _ \ |/ / | |  | || '_ \ / _ \
 | |  | | (_| | (__| |_) | (_) | (_) |   <  | |__| || |_) || (_) |
 |_|  |_|\___/ \___/____/ \___/ \___/|_|\_\  \____/ | .__/  \___/ 
                                                    | |           
                                                    |_|           
EOF
echo -e "${PURPLE}      --- Tactical Workstation Deployment v2.1 ---${NC}\n"

#!/bin/bash
# --- Tactical Deployment v2.2 ---
REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

echo -e "\033[0;34m[*] Desplegando configuración desde estructura consolidada...\033[0m"

# 1. Crear directorios en el sistema
mkdir -p "$REAL_HOME"/.config/{bspwm,sxhkd,polybar,kitty,nvim}

# 2. Copiar Configuraciones (Rutas nuevas)
cp -rv ./config/bspwm/* "$REAL_HOME"/.config/bspwm/
cp -rv ./config/sxhkd/* "$REAL_HOME"/.config/sxhkd/
cp -rv ./config/polybar/* "$REAL_HOME"/.config/polybar/
cp -rv ./config/kitty/* "$REAL_HOME"/.config/kitty/
cp -rv ./config/nvim/* "$REAL_HOME"/.config/nvim/
cp -v ./config/zshrc_backup "$REAL_HOME"/.zshrc

# 3. Scripts y Binarios
mkdir -p "$REAL_HOME"/scripts "$REAL_HOME"/.local/bin
cp -rv ./scripts/* "$REAL_HOME"/scripts/
cp -v ./bin/phoenix-hud.sh "$REAL_HOME"/.local/bin/

# 4. Hardware (MacBook Pro)
cp -v ./hardware/mbpfan.conf /etc/mbpfan.conf 2>/dev/null

# 5. Permisos
chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME"/.config
chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME"/scripts
chmod +x "$REAL_HOME"/scripts/*.sh
