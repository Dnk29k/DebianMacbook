#!/bin/bash
# =================================================================
# MASTER SETUP SCRIPT - DEBIAN MACBOOK PRO (OPTIMIZED)
# =================================================================
set -e # Detener si hay errores

echo "🚀 Iniciando despliegue de arquitectura técnica..."

# --- FASE 1: REPOSITORIOS ---
echo "📦 Configurando repositorios non-free..."
sudo sed -i 's/main/main contrib non-free non-free-firmware/g' /etc/apt/sources.list
sudo apt update

# --- FASE 2: INSTALACIÓN DE NÚCLEO ---
echo "🛠️ Instalando stack de software y drivers..."
sudo apt install -y \
i3 bspwm sxhkd picom polybar kitty rofi feh \
network-manager firmware-b43-installer brightnessctl \
curl unzip git zsh fonts-font-awesome pulseaudio pavucontrol

# --- FASE 3: BLINDAJE WI-FI (ELIMINACIÓN DE AMNESIA) ---
echo "📡 Ejecutando corrección de persistencia b43..."
# Eliminamos el driver que causa el Error -22 [cite: 2026-02-13]
sudo apt purge -y broadcom-sta-dkms || true

# Neutralización agresiva de blacklists [cite: 2026-02-13]
sudo sed -i 's/^blacklist b43/#blacklist b43/g' /etc/modprobe.d/*.conf 2>/dev/null || true
sudo sed -i 's/^blacklist b43/#blacklist b43/g' /lib/modprobe.d/*.conf 2>/dev/null || true

# Configuración de estabilidad y carga temprana [cite: 2026-02-13]
echo "options b43 pio=1 qos=0" | sudo tee /etc/modprobe.d/macbook-wifi.conf
echo "b43" | sudo tee /etc/modules-load.d/b43.conf

# Reconstrucción del kernel para aceptar los cambios
sudo update-initramfs -u
sudo rfkill unblock all

# --- FASE 4: TIPOGRAFÍA (NERD FONTS) ---
if [ ! -f ~/.local/share/fonts/HackNerdFont-Regular.ttf ]; then
    echo "🔤 Instalando Hack Nerd Font..."
    mkdir -p ~/.local/share/fonts
    TEMP_DIR=$(mktemp -d)
    cd $TEMP_DIR
    curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
    unzip -o Hack.zip -d ~/.local/share/fonts
    fc-cache -fv
    cd -
else
    echo "✅ Fuentes ya instaladas."
fi

echo "🏁 Fase de sistema completada. Procede con post-install.sh"
