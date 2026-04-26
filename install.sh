```bash
#!/bin/bash
# =============================================================
#  MacBook-Debian — Tactical Workstation Deployment v4.2
#  SSD Migration Ready + SD-AUTH Bypass Support — 2026-04
#  Stack: Debian 12 + bspwm + picom + polybar + kitty + zsh
#         + Ollama + Kimi-K2.5 + Claude Code + SD-AUTH
#  Usage: sudo bash install.sh [--skip-sd-auth]
# =============================================================

set -euo pipefail
trap 'echo -e "\n${RED}[ERROR]${NC} Fallo en línea $LINENO. Abortando." >&2; exit 1' ERR

# --- Colores ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- Detectar Usuario Real (incluso con sudo) ---
REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Parse flags (SD-AUTH bypass para migración) ---
SKIP_SD_AUTH=0
for arg in "$@"; do
  case $arg in
    --skip-sd-auth) SKIP_SD_AUTH=1; shift ;;
    *) echo -e "${RED}[!] Flag desconocido: $arg${NC}"; exit 1 ;;
  esac
done

# --- Verificar que se ejecuta como root ---
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[!] Ejecuta con sudo: sudo bash install.sh${NC}"
    exit 1
fi

# --- Banner ---
clear
echo -e "${BLUE}"
cat << "EOF"
 ███╗   ███╗ █████╗  ██████╗██████╗  ██████╗  ██████╗ ██╗  ██╗
 ████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██║ ██╔╝
 ██╔████╔██║███████║██║     ██████╔╝██║   ██║██║   ██║█████╔╝
 ██║╚██╔╝██║██╔══██║██║     ██╔══██╗██║   ██║██║   ██║██╔═██╗
 ██║ ╚═╝ ██║██║  ██║╚██████╗██████╔╝╚██████╔╝╚██████╔╝██║  ██╗
 ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝
EOF
echo -e "${PURPLE}      --- MacBook Debian Tactical Workstation v4.2 ---${NC}"
echo -e "${BLUE}[*] Usuario: ${YELLOW}${REAL_USER}${NC} → ${YELLOW}${REAL_HOME}${NC}"
echo -e "${BLUE}[*] Repo:    ${YELLOW}${SCRIPT_DIR}${NC}"
if [[ $SKIP_SD_AUTH -eq 1 ]]; then
  echo -e "${YELLOW}[!] MODO MIGRACIÓN: SD-AUTH desactivado temporalmente${NC}"
fi
echo

# =============================================================
# FUNCIÓN: Gestionar SD-AUTH (nueva)
# =============================================================
manage_sd_auth() {
    echo -e "${BLUE}[*] Configurando SD-AUTH...${NC}"

    # Deploy del script de validación
    if [[ -f "${SCRIPT_DIR}/config/systemd/check_key.sh" ]]; then
        cp -v "${SCRIPT_DIR}/config/systemd/check_key.sh" /usr/local/bin/check_key.sh
        chmod +x /usr/local/bin/check_key.sh
        echo -e "${GREEN}  [✓] check_key.sh instalado${NC}"
    fi

    # Deploy del archivo de clave (si existe en el repo)
    if [[ -f "${SCRIPT_DIR}/config/systemd/key_data" ]]; then
        mkdir -p /usr/local/etc
        cp -v "${SCRIPT_DIR}/config/systemd/key_data" /usr/local/etc/key_data
        chmod 600 /usr/local/etc/key_data
        echo -e "${GREEN}  [✓] key_data instalado (permisos 600)${NC}"
    fi

    # Deploy del servicio systemd
    if [[ -f "${SCRIPT_DIR}/config/systemd/check_key.service" ]]; then
        cp -v "${SCRIPT_DIR}/config/systemd/check_key.service" /etc/systemd/system/
        systemctl daemon-reload

        if [[ $SKIP_SD_AUTH -eq 1 ]]; then
            # Modo migración: desactivar temporalmente
            systemctl stop check_key.service 2>/dev/null || true
            systemctl disable check_key.service 2>/dev/null || true
            systemctl mask check_key.service 2>/dev/null || true
            echo -e "${YELLOW}  [⚠] check_key.service desactivado (modo migración)${NC}"
        else
            # Modo normal: habilitar
            systemctl enable check_key.service 2>/dev/null || true
            echo -e "${GREEN}  [✓] check_key.service habilitado${NC}"
        fi
    fi
}

# =============================================================
# FUNCIÓN: Optimizaciones para SSD (nueva)
# =============================================================
apply_ssd_optimizations() {
    echo -e "${BLUE}[*] Aplicando optimizaciones para SSD...${NC}"

    # 1. Habilitar TRIM semanal
    if ! systemctl is-enabled fstrim.timer &>/dev/null; then
        systemctl enable --now fstrim.timer
        echo -e "${GREEN}  [✓] fstrim.timer activado${NC}"
    fi

    # 2. Ajustar swappiness para reducir escrituras en swap
    if [[ ! -f /etc/sysctl.d/99-ssd.conf ]]; then
        cat > /etc/sysctl.d/99-ssd.conf << 'EOF'
# Optimizaciones para SSD - DebianMacbook
vm.swappiness=10
vm.vfs_cache_pressure=50
EOF
        sysctl -p /etc/sysctl.d/99-ssd.conf
        echo -e "${GREEN}  [✓] Ajustes de VM aplicados${NC}"
    fi

    # 3. Optimizar fstab (solo si es instalación limpia)
    if [[ -f /etc/fstab ]] && grep -q "ext4" /etc/fstab; then
        if ! grep -q "noatime" /etc/fstab; then
            cp /etc/fstab /etc/fstab.bak.$(date +%F)
            sed -i 's/defaults/defaults,noatime/' /etc/fstab
            echo -e "${GREEN}  [✓] noatime añadido a fstab${NC}"
        fi
    fi

    echo -e "${GREEN}[✓] Optimizaciones SSD completadas${NC}"
}

# =============================================================
# FUNCIÓN: Instalar dependencias base
# =============================================================
install_deps() {
    echo -e "${BLUE}[*] Actualizando repos...${NC}"
    apt-get update -qq

    local pkgs=(
        # Entorno gráfico
        bspwm sxhkd picom polybar rofi feh
        # Terminal y shell
        zsh zsh-autosuggestions zsh-syntax-highlighting
        # Herramientas modernas CLI
        bat lsd curl wget git unzip
        # Fuentes
        fonts-hack-ttf
        # Editor
        neovim
        # Hardware MacBook
        mbpfan
        # Red y herramientas base
        network-manager iproute2 net-tools
        # Utilidades
        xorg xinit x11-utils x11-xserver-utils
        xclip xdotool
        # Python (para scripts de automatización)
        python3 python3-pip python3-venv
        # Utilidades para SD-AUTH y auditoría
        uuid-runtime logrotate
    )

    echo -e "${BLUE}[*] Instalando paquetes base...${NC}"
    apt-get install -y "${pkgs[@]}" 2>/dev/null || true

    echo -e "${GREEN}[✓] Dependencias base instaladas.${NC}"
}

# =============================================================
# FUNCIÓN: Instalar Kitty terminal
# =============================================================
install_kitty() {
    if command -v kitty &>/dev/null; then
        echo -e "${YELLOW}[~] Kitty ya instalado: $(kitty --version)${NC}"
        return
    fi

    echo -e "${BLUE}[*] Instalando Kitty terminal...${NC}"
    sudo -u "$REAL_USER" curl -L https://sw.kovidgoyal.net/kitty/installer.sh | \
        sudo -u "$REAL_USER" bash /dev/stdin launch=n

    ln -sf "$REAL_HOME/.local/kitty.app/bin/kitty" /usr/local/bin/kitty
    ln -sf "$REAL_HOME/.local/kitty.app/bin/kitten" /usr/local/bin/kitten

    echo -e "${GREEN}[✓] Kitty instalado.${NC}"
}

# =============================================================
# FUNCIÓN: Instalar Powerlevel10k
# =============================================================
install_p10k() {
    local p10k_dir="$REAL_HOME/powerlevel10k"

    if [[ -d "$p10k_dir" ]]; then
        echo -e "${YELLOW}[~] Powerlevel10k ya existe. Actualizando...${NC}"
        sudo -u "$REAL_USER" git -C "$p10k_dir" pull --quiet
        return
    fi

    echo -e "${BLUE}[*] Instalando Powerlevel10k...${NC}"
    sudo -u "$REAL_USER" git clone --depth=1 \
        https://github.com/romkatv/powerlevel10k.git "$p10k_dir"

    echo -e "${GREEN}[✓] Powerlevel10k instalado.${NC}"
}

# =============================================================
# FUNCIÓN: Instalar Ollama
# =============================================================
install_ollama() {
    if command -v ollama &>/dev/null; then
        echo -e "${YELLOW}[~] Ollama ya instalado: $(ollama --version 2>/dev/null || echo 'versión desconocida')${NC}"
        return
    fi

    echo -e "${BLUE}[*] Instalando Ollama...${NC}"
    curl -fsSL https://ollama.com/install.sh | bash

    systemctl enable ollama
    systemctl start ollama

    echo -e "${GREEN}[✓] Ollama instalado y activo.${NC}"
    echo -e "${YELLOW}[!] Recuerda descargar el modelo: ollama pull kimi-k2.5:cloud${NC}"
}

# =============================================================
# FUNCIÓN: Instalar Claude Code (instalador nativo)
# =============================================================
install_claude() {
    if command -v claude &>/dev/null; then
        echo -e "${YELLOW}[~] Claude Code ya instalado. Actualizando...${NC}"
        sudo -u "$REAL_USER" claude update 2>/dev/null || true
        return
    fi

    echo -e "${BLUE}[*] Instalando Claude Code (instalador nativo)...${NC}"
    sudo -u "$REAL_USER" bash -c "curl -fsSL https://claude.ai/install.sh | sh"

    echo -e "${GREEN}[✓] Claude Code instalado en ~/.local/bin/claude${NC}"
}

# =============================================================
# FUNCIÓN: Backup de configuraciones existentes
# =============================================================
backup_configs() {
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    local backed_up=0

    echo -e "\n${BLUE}[*] Comprobando configuraciones existentes...${NC}"

    local configs=(
        "$REAL_HOME/.zshrc"
        "$REAL_HOME/.config/bspwm"
        "$REAL_HOME/.config/sxhkd"
        "$REAL_HOME/.config/polybar"
        "$REAL_HOME/.config/kitty"
        "$REAL_HOME/.config/nvim"
        "$REAL_HOME/.config/picom"
    )

    for cfg in "${configs[@]}"; do
        if [[ -e "$cfg" ]]; then
            cp -r "$cfg" "${cfg}.bak.${timestamp}"
            echo -e "${YELLOW}  [bak] ${cfg}.bak.${timestamp}${NC}"
            ((backed_up++))
        fi
    done

    if [[ $backed_up -gt 0 ]]; then
        echo -e "${GREEN}[✓] ${backed_up} configs respaldadas (${timestamp}).${NC}"
    else
        echo -e "${GREEN}[✓] Sin configuraciones previas que respaldar.${NC}"
    fi
}

# =============================================================
# FUNCIÓN: Copiar configuraciones
# =============================================================
deploy_configs() {
    echo -e "\n${BLUE}[*] Desplegando configuraciones...${NC}"

    mkdir -p "$REAL_HOME"/.config/{bspwm/scripts,sxhkd,polybar/scripts/themes,polybar/fonts,kitty,nvim,picom,bin}
    mkdir -p "$REAL_HOME"/{scripts,.local/bin,ovpn}

    # --- bspwm ---
    if [[ -d "${SCRIPT_DIR}/config/bspwm" ]]; then
        cp -rv "${SCRIPT_DIR}/config/bspwm/." "$REAL_HOME/.config/bspwm/"
    fi

    # --- sxhkd ---
    if [[ -d "${SCRIPT_DIR}/config/sxhkd" ]]; then
        cp -rv "${SCRIPT_DIR}/config/sxhkd/." "$REAL_HOME/.config/sxhkd/"
    fi

    # --- polybar ---
    if [[ -d "${SCRIPT_DIR}/config/polybar" ]]; then
        cp -rv "${SCRIPT_DIR}/config/polybar/." "$REAL_HOME/.config/polybar/"
    fi

    # --- kitty ---
    if [[ -f "${SCRIPT_DIR}/config/kitty/kitty.conf" ]]; then
        cp -v "${SCRIPT_DIR}/config/kitty/kitty.conf" "$REAL_HOME/.config/kitty/kitty.conf"
    fi

    # --- nvim ---
    if [[ -d "${SCRIPT_DIR}/config/nvim" ]]; then
        cp -rv "${SCRIPT_DIR}/config/nvim/." "$REAL_HOME/.config/nvim/"
    fi

    # --- zshrc ---
    if [[ -f "${SCRIPT_DIR}/config/zshrc_backup" ]]; then
        sed "s|/home/dnk29|${REAL_HOME}|g" "${SCRIPT_DIR}/config/zshrc_backup" > "$REAL_HOME/.zshrc"
        echo -e "${GREEN}  [✓] .zshrc desplegado (rutas adaptadas a ${REAL_USER})${NC}"
    fi

    # --- bspwmrc ---
    if [[ -f "$REAL_HOME/.config/bspwm/bspwmrc" ]]; then
        sed -i "s|/home/dnk29|${REAL_HOME}|g" "$REAL_HOME/.config/bspwm/bspwmrc" 2>/dev/null || true
    fi

    # --- Scripts ---
    if [[ -d "${SCRIPT_DIR}/scripts" ]]; then
        cp -rv "${SCRIPT_DIR}/scripts/." "$REAL_HOME/scripts/"
    fi

    # --- bin ---
    if [[ -f "${SCRIPT_DIR}/bin/phoenix-hud.sh" ]]; then
        cp -v "${SCRIPT_DIR}/bin/phoenix-hud.sh" "$REAL_HOME/.local/bin/"
    fi

    touch "$REAL_HOME/.config/bin/target"

    echo -e "${GREEN}[✓] Configuraciones desplegadas.${NC}"
}

# =============================================================
# FUNCIÓN: Configurar bspwmrc correctamente
# =============================================================
fix_bspwmrc() {
    local bspwmrc="$REAL_HOME/.config/bspwm/bspwmrc"

    if [[ ! -f "$bspwmrc" ]]; then
        return
    fi

    echo -e "\n${BLUE}[*] Corrigiendo bspwmrc...${NC}"

    sed -i '/bspc rule -a "\*" -o state=floating/d' "$bspwmrc"
    sed -i 's|^picom &$|picom --config ~/.config/picom/picom.conf --daemon \&|' "$bspwmrc"
    sed -i "s|/home/dnk29/.config/polybar/launch.sh|${REAL_HOME}/.config/polybar/launch.sh|g" "$bspwmrc"

    echo -e "${GREEN}[✓] bspwmrc corregido.${NC}"
}

# =============================================================
# FUNCIÓN: Crear picom.conf optimizado para MacBook
# =============================================================
deploy_picom() {
    local picom_conf="$REAL_HOME/.config/picom/picom.conf"

    if [[ -f "$picom_conf" ]]; then
        echo -e "${YELLOW}[~] picom.conf ya existe. Omitiendo.${NC}"
        return
    fi

    echo -e "\n${BLUE}[*] Creando picom.conf optimizado para MacBook...${NC}"

    cat > "$picom_conf" << 'PICOM'
backend = "xrender";
vsync = false;
use-damage = true;
corner-radius = 0;
rounded-corners-exclude = [];
round-borders = 0;
shadow = true;
shadow-radius = 6;
shadow-opacity = 0.35;
shadow-offset-x = -6;
shadow-offset-y = -6;
shadow-exclude = [
    "class_g = 'Polybar'",
    "class_g = 'Rofi'",
    "_GTK_FRAME_EXTENTS",
    "window_type = 'menu'",
    "window_type = 'dropdown_menu'",
    "window_type = 'popup_menu'",
    "window_type = 'tooltip'"
];
fading = false;
inactive-opacity = 1.0;
active-opacity = 1.0;
frame-opacity = 1.0;
inactive-opacity-override = false;
focus-exclude = [
    "class_g = 'Cairo-clock'",
    "class_g = 'slop'"
];
opacity-rule = [
    "90:class_g = 'kitty' && focused",
    "75:class_g = 'kitty' && !focused",
    "95:class_g = 'Rofi'",
    "100:class_g = 'Polybar'"
];
blur-method = "none";
blur-strength = 0;
blur-background = false;
blur-background-frame = false;
blur-background-fixed = false;
blur-background-exclude = [
    "window_type = 'dock'",
    "window_type = 'desktop'",
    "class_g = 'slop'",
    "_GTK_FRAME_EXTENTS"
];
detect-rounded-corners = false;
detect-client-opacity = true;
detect-transient = true;
detect-client-leader = true;
mark-wmwin-focused = true;
mark-ovredir-focused = true;
glx-copy-from-front = false;
unredir-if-possible = false;
wintypes:
{
    tooltip = { fade = false; shadow = true; opacity = 0.9; focus = true; full-shadow = false; };
    dock = { shadow = false; clip-shadow-above = true; }
    dnd = { shadow = false; }
    popup_menu = { opacity = 1.0; shadow = false; }
    dropdown_menu = { opacity = 1.0; shadow = false; }
};
PICOM

    echo -e "${GREEN}[✓] picom.conf creado.${NC}"
}

# =============================================================
# FUNCIÓN: Configurar variables de entorno para Ollama/Claude
# =============================================================
configure_ai_env() {
    echo -e "\n${BLUE}[*] Configurando variables de entorno para Ollama + Claude...${NC}"

    local zshrc="$REAL_HOME/.zshrc"

    if ! grep -q "OLLAMA_NUM_GPU_LAYERS" "$zshrc" 2>/dev/null; then
        cat >> "$zshrc" << 'AIENV'

# --- OLLAMA + CLAUDE CODE ---
# GPU legacy NVIDIA 320M — forzar CPU para evitar warning de drivers legacy
export OLLAMA_NUM_GPU_LAYERS=0
export OLLAMA_DEBUG=0
# Claude Code apunta a Ollama local con Kimi
export ANTHROPIC_BASE_URL="http://localhost:11434/v1"
export ANTHROPIC_MODEL="kimi-k2.5:cloud"
AIENV
        echo -e "${GREEN}[✓] Variables de entorno Ollama/Claude añadidas al .zshrc${NC}"
    else
        echo -e "${YELLOW}[~] Variables Ollama ya presentes en .zshrc${NC}"
    fi
}

# =============================================================
# FUNCIÓN: Hardware MacBook
# =============================================================
deploy_hardware() {
    echo -e "\n${BLUE}[*] Configurando hardware MacBook...${NC}"

    if [[ -f "${SCRIPT_DIR}/hardware/mbpfan.conf" ]]; then
        cp -v "${SCRIPT_DIR}/hardware/mbpfan.conf" /etc/mbpfan.conf
        systemctl enable --now mbpfan 2>/dev/null && \
            echo -e "${GREEN}[✓] mbpfan activo.${NC}" || \
            echo -e "${YELLOW}[!] mbpfan no disponible en este sistema.${NC}"
    fi

    local product
    product=$(cat /sys/class/dmi/id/product_name 2>/dev/null || echo "unknown")

    if echo "$product" | grep -qi "macbook"; then
        echo -e "${BLUE}[*] MacBook detectado — configurando Wi-Fi Broadcom...${NC}"

        cat > /etc/modprobe.d/b43-fix.conf << 'B43'
# Fix Broadcom BCM4322 en MacBook
blacklist wl
blacklist b44
blacklist ssb
options b43 pio=1 qos=0
B43

        echo "b43" > /etc/modules-load.d/b43.conf
        update-initramfs -u 2>/dev/null && \
            echo -e "${GREEN}[✓] initramfs regenerado con b43.${NC}" || \
            echo -e "${YELLOW}[!] update-initramfs falló — hazlo manualmente.${NC}"
    fi
}

# =============================================================
# FUNCIÓN: Configurar zsh como shell por defecto
# =============================================================
set_default_shell() {
    local current_shell
    current_shell=$(getent passwd "$REAL_USER" | cut -d: -f7)

    if [[ "$current_shell" != "$(which zsh)" ]]; then
        echo -e "\n${BLUE}[*] Estableciendo zsh como shell por defecto...${NC}"
        chsh -s "$(which zsh)" "$REAL_USER"
        echo -e "${GREEN}[✓] Shell cambiado a zsh.${NC}"
    else
        echo -e "${YELLOW}[~] zsh ya es el shell por defecto.${NC}"
    fi
}

# =============================================================
# FUNCIÓN: Permisos finales
# =============================================================
set_permissions() {
    echo -e "\n${BLUE}[*] Aplicando permisos...${NC}"

    chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME/.config"
    chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME/scripts" 2>/dev/null || true
    chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME/.local" 2>/dev/null || true

    find "$REAL_HOME/scripts" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    find "$REAL_HOME/.config/bspwm/scripts" -type f -exec chmod +x {} \; 2>/dev/null || true
    find "$REAL_HOME/.config/polybar" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    chmod +x "$REAL_HOME/.local/bin/phoenix-hud.sh" 2>/dev/null || true

    if [[ -f "$REAL_HOME/.config/bin/.key_data" ]]; then
        chown root:root "$REAL_HOME/.config/bin/.key_data"
        chmod 600 "$REAL_HOME/.config/bin/.key_data"
        echo -e "${GREEN}[✓] .key_data protegido (root:root 600).${NC}"
    fi

    echo -e "${GREEN}[✓] Permisos aplicados.${NC}"
}

# =============================================================
# FUNCIÓN: Resumen post-instalación
# =============================================================
show_summary() {
    echo -e "\n${GREEN}╔══════════════════════════════════════════════════════╗"
    echo -e "║         DESPLIEGUE COMPLETADO — v4.2                 ║"
    echo -e "╠══════════════════════════════════════════════════════╣"
    echo -e "║  Usuario:  ${YELLOW}${REAL_USER}${GREEN}                                    ║"
    echo -e "║  Home:     ${YELLOW}${REAL_HOME}${GREEN}                         ║"
    if [[ $SKIP_SD_AUTH -eq 1 ]]; then
        echo -e "║  ${YELLOW}[⚠] SD-AUTH desactivado — reactivar post-migración${GREEN}  ║"
    fi
    echo -e "╠══════════════════════════════════════════════════════╣"
    echo -e "║  PASOS MANUALES PENDIENTES:                          ║"
    echo -e "║  1. Descarga el modelo:                              ║"
    echo -e "║     ${YELLOW}ollama pull kimi-k2.5:cloud${GREEN}                       ║"
    echo -e "║  2. Autentícate en Claude:                           ║"
    echo -e "║     ${YELLOW}claude auth${GREEN}                                       ║"
    echo -e "║  3. Configura NordVPN:                               ║"
    echo -e "║     ${YELLOW}nordvpn login${GREEN}                                     ║"
    echo -e "║  4. Coloca tu .ovpn en ~/ovpn/                       ║"
    echo -e "║  5. Reinicia la sesión o ejecuta: ${YELLOW}exec zsh${GREEN}           ║"
    if [[ $SKIP_SD_AUTH -eq 1 ]]; then
        echo -e "║  6. ${YELLOW}Reactivar SD-AUTH: sudo systemctl unmask check_key${GREEN} ║"
    fi
    echo -e "╚══════════════════════════════════════════════════════╝${NC}\n"
}

# =============================================================
# EJECUCIÓN PRINCIPAL
# =============================================================
echo -e "${CYAN}[?] ¿Qué deseas instalar?${NC}"
echo "  1) Instalación completa (todo)"
echo "  2) Solo configuraciones (dotfiles)"
echo "  3) Solo herramientas (paquetes + Ollama + Claude)"
echo "  4) Solo hardware MacBook"
read -rp "Opción [1-4]: " install_mode

case "$install_mode" in
    1)
        install_deps
        install_kitty
        install_p10k
        install_ollama
        install_claude
        backup_configs
        deploy_configs
        fix_bspwmrc
        deploy_picom
        configure_ai_env
        deploy_hardware
        manage_sd_auth
        apply_ssd_optimizations
        set_default_shell
        set_permissions
        ;;
    2)
        backup_configs
        deploy_configs
        fix_bspwmrc
        deploy_picom
        configure_ai_env
        manage_sd_auth
        apply_ssd_optimizations
        set_permissions
        ;;
    3)
        install_deps
        install_kitty
        install_p10k
        install_ollama
        install_claude
        set_default_shell
        ;;
    4)
        deploy_hardware
        manage_sd_auth
        ;;
    *)
        echo -e "${RED}[!] Opción inválida.${NC}"
        exit 1
        ;;
esac

show_summary
