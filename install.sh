#!/bin/bash
# =============================================================
#  MacBook-Debian — Tactical Workstation Deployment v3.0
#  Reescrito tras auditoría de seguridad — 2026-04-05
# =============================================================

set -euo pipefail
trap 'echo -e "
${RED}[ERROR]${NC} Fallo en línea $LINENO. Abortando." >&2; exit 1' ERR

# --- Colores ---
GREEN='\u001B[0;32m'
YELLOW='\u001B[1;33m'
BLUE='\u001B[0;34m'
RED='\u001B[0;31m'
PURPLE='\u001B[0;35m'
NC='\u001B[0m'

# --- Detectar Usuario Real (incluso con sudo) ---
REAL_USER=${SUDO_USER:-$USER}
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

# --- Verificar que se ejecuta como root ---
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[!] Ejecuta con sudo: sudo bash install.sh${NC}"
    exit 1
fi

# --- Banner ---
clear
echo -e "${BLUE}"
cat << "EOF"
  __  __            ____             _      _    _
 |  /  |          |  _            | |    | |  | |
 |   / | __ _  ___| |_) | ___  ___| | __ | |  | | _ __   ___
 | |/| |/ _` |/ __|  _ < / _  / _  |/ / | |  | || '_  / _ \
 | |  | | (_| | (__| |_) | (_) | (_) |   <  | |__| || |_) || (_) |
 |_|  |_|___/ ___|____/ ___/ ___/|_|_  ____/ | .__/  ___/
                                                    | |
                                                    |_|
EOF
echo -e "${PURPLE}      --- Tactical Workstation Deployment v3.0 ---${NC}
"
echo -e "${BLUE}[*] Usuario: ${YELLOW}${REAL_USER}${NC} → ${YELLOW}${REAL_HOME}${NC}
"

# =============================================================
# FUNCIÓN: Verificar dependencias
# =============================================================
check_deps() {
    local missing=()
    local deps=("bat" "lsd" "nvim" "feh" "picom" "bspwm" "polybar" "kitty" "zsh" "mbpfan")

    echo -e "${BLUE}[*] Verificando dependencias...${NC}"
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${YELLOW}[!] No encontrados: ${missing[*]}${NC}"
        echo -e "${YELLOW}    Las configs se copiarán pero no funcionarán hasta instalarlos.${NC}"
        read -p "    ¿Continuar de todas formas? [s/N]: " confirm
        [[ "$confirm" =~ ^[sS]$ ]] || exit 0
    else
        echo -e "${GREEN}[✓] Todas las dependencias encontradas.${NC}"
    fi
}

# =============================================================
# FUNCIÓN: Backup de configuraciones existentes
# =============================================================
backup_configs() {
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    local backed_up=0

    echo -e "
${BLUE}[*] Comprobando configuraciones existentes...${NC}"

    local configs=(
        "$REAL_HOME/.zshrc"
        "$REAL_HOME/.config/bspwm"
        "$REAL_HOME/.config/sxhkd"
        "$REAL_HOME/.config/polybar"
        "$REAL_HOME/.config/kitty"
        "$REAL_HOME/.config/nvim"
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
    echo -e "
${BLUE}[*] Desplegando configuraciones...${NC}"

    mkdir -p "$REAL_HOME"/.config/{bspwm/scripts,sxhkd,polybar,kitty,nvim,bin}
    mkdir -p "$REAL_HOME"/{scripts,.local/bin}

    cp -rv ./config/bspwm/*        "$REAL_HOME"/.config/bspwm/
    cp -rv ./config/sxhkd/*        "$REAL_HOME"/.config/sxhkd/
    cp -rv ./config/polybar/*       "$REAL_HOME"/.config/polybar/
    cp -rv ./config/kitty/*         "$REAL_HOME"/.config/kitty/
    cp -rv ./config/nvim/*          "$REAL_HOME"/.config/nvim/
    cp -v  ./config/zshrc_backup    "$REAL_HOME"/.zshrc
    cp -rv ./scripts/*              "$REAL_HOME"/scripts/
    cp -v  ./bin/phoenix-hud.sh     "$REAL_HOME"/.local/bin/

    echo -e "${GREEN}[✓] Configuraciones desplegadas.${NC}"
}

# =============================================================
# FUNCIÓN: Hardware MacBook
# =============================================================
deploy_hardware() {
    echo -e "
${BLUE}[*] Configurando hardware MacBook...${NC}"

    if [[ ! -f "./hardware/mbpfan.conf" ]]; then
        echo -e "${YELLOW}[!] hardware/mbpfan.conf no encontrado — omitiendo.${NC}"
        return
    fi

    if cp -v ./hardware/mbpfan.conf /etc/mbpfan.conf; then
        echo -e "${GREEN}[✓] mbpfan.conf instalado.${NC}"
        systemctl enable --now mbpfan 2>/dev/null && \
            echo -e "${GREEN}[✓] mbpfan activo.${NC}" || \
            echo -e "${YELLOW}[!] mbpfan no pudo habilitarse automáticamente.${NC}"
    else
        echo -e "${RED}[!] Error copiando mbpfan.conf — ¿permisos de root?${NC}"
    fi
}

# =============================================================
# FUNCIÓN: Permisos finales
# =============================================================
set_permissions() {
    echo -e "
${BLUE}[*] Aplicando permisos...${NC}"

    chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME"/.config
    chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME"/scripts
    chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME"/.local/bin
    chmod +x "$REAL_HOME"/scripts/*.sh
    chmod +x "$REAL_HOME"/.local/bin/phoenix-hud.sh

    # Protección crítica del secreto SD-AUTH
    if [[ -f "$REAL_HOME/DebianMacbook/.config/bin/.key_data" ]]; then
        chown root:root "$REAL_HOME/DebianMacbook/.config/bin/.key_data"
        chmod 600 "$REAL_HOME/DebianMacbook/.config/bin/.key_data"
        echo -e "${GREEN}[✓] .key_data protegido (root:root 600).${NC}"
    fi

    echo -e "${GREEN}[✓] Permisos aplicados.${NC}"
}

# =============================================================
# EJECUCIÓN PRINCIPAL
# =============================================================
check_deps
backup_configs
deploy_configs
deploy_hardware
set_permissions

echo -e "
${GREEN}╔══════════════════════════════════════════════╗"
echo -e "║  Despliegue completado. Reinicia la sesión.  ║"
echo -e "╚══════════════════════════════════════════════╝${NC}
"
