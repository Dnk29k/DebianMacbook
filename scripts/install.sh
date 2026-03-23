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

# --- 1. Verificación de privilegios ---
if [ "$EUID" -ne 0 ]; then 
  echo -e "${RED}[!] Error: Por favor, ejecuta el script como root (sudo).${NC}"
  exit 1
fi

echo -e "${YELLOW}[*] Usuario detectado: ${BLUE}$REAL_USER${YELLOW} en ${BLUE}$REAL_HOME${NC}"

# --- 2. Actualización y Dependencias ---
echo -e "${YELLOW}[*] Actualizando repositorios e instalando arsenal base...${NC}"
apt update && apt install -y \
    bspwm sxhkd polybar kitty zsh \
    network-manager nftables ufw \
    git curl wget feh rofi xclip \
    build-essential libssl-dev zlib1g-dev \
    fonts-noto-color-emoji

# --- 3. Parches de Hardware (MacBook Pro 2010) ---
echo -e "${YELLOW}[*] Configurando optimizaciones para MacBook Pro (Nvidia/Broadcom)...${NC}"
echo "blacklist b43" > /etc/modprobe.d/blacklist.conf
echo -e "${GREEN}[+] Blacklist b43 aplicada para estabilidad de wlan0.${NC}"

# --- 4. Despliegue de Configuraciones (Dotfiles) ---
echo -e "${YELLOW}[*] Desplegando archivos de configuración táctica...${NC}"
mkdir -p "$REAL_HOME"/.config/{bspwm,sxhkd,polybar,kitty,nvim}

# Copiamos usando el contenido del repo actual
cp -rv ./config/bspwm/* "$REAL_HOME"/.config/bspwm/
cp -rv ./config/sxhkd/* "$REAL_HOME"/.config/sxhkd/
cp -rv ./config/polybar/* "$REAL_HOME"/.config/polybar/
cp -v ./config/zsh_backup "$REAL_HOME"/.zshrc

# --- 5. Sincronización Shell (Root Link) ---
echo -e "${YELLOW}[*] Sincronizando entorno de Root con usuario $REAL_USER...${NC}"
ln -sf "$REAL_HOME"/.zshrc /root/.zshrc
chsh -s $(which zsh) "$REAL_USER"
chsh -s $(which zsh) root

# --- 6. Herramientas y Symlinks (Fix Burp) ---
echo -e "${YELLOW}[*] Verificando arsenal de herramientas...${NC}"
if [ -d "/opt/BurpSuiteCommunity" ]; then
    ln -sf /opt/BurpSuiteCommunity/BurpSuiteCommunity /usr/local/bin/burpsuite
    echo -e "${GREEN}[+] Symlink de Burp Suite creado.${NC}"
else
    echo -e "${RED}[!] Advertencia: Burp Suite no detectado en /opt/.${NC}"
fi

# --- 7. Organización de Scripts y Permisos ---
echo -e "${YELLOW}[*] Instalando scripts de automatización...${NC}"
mkdir -p "$REAL_HOME"/scripts
cp -rv ./scripts/* "$REAL_HOME"/scripts/
chmod +x "$REAL_HOME"/scripts/*.sh

# Ajustar propietarios para que no todo pertenezca a root
chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME"/scripts
chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME"/.config
chown "$REAL_USER":"$REAL_USER" "$REAL_HOME"/.zshrc

# --- Finalización ---
echo -e "\n${BLUE}======================================================${NC}"
echo -e "${GREEN}[✔] Despliegue completado con éxito.${NC}"
echo -e "${YELLOW}[!] Reinicia para aplicar cambios de drivers y Shell.${NC}"
echo -e "${BLUE}======================================================${NC}\n"
