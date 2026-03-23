#!/bin/bash

# CONFIGURACIÓN DEL ARQUITECTO
USER="Dnk29k"
REPO="DebianMacbook"
EMAIL="tu-email@ejemplo.com" # <--- CAMBIA ESTO por tu email de GitHub

echo "🏗️  Construyendo estructura de archivos del proyecto..."

# 1. Crear carpetas
mkdir -p ~/Proyectos/$REPO/{scripts,docs,dotfiles}
cd ~/Proyectos/$REPO

# 2. Inyectar Roadmap y Documentación Técnica
cat <<EOF > docs/roadmap.md
# 🗺️ Hoja de Ruta
Fase 1: Transición a hardware real.
Fase 2: Persistencia Wi-Fi mediante limpieza de blacklists [cite: 2026-02-13].
Fase 3: Optimización i3wm y Picom.
EOF

cat <<EOF > docs/troubleshooting.md
# 🛠️ Solución de Errores
Error: Wi-Fi desaparece tras reinicio.
Causa: Módulo b43 bloqueado por archivos en /etc/modprobe.d/ [cite: 2026-02-13].
Solución: Neutralizar blacklist b43 y usar modules-load.d [cite: 2026-02-13].
EOF

# 3. Copiar tus configuraciones reales (Dotfiles)
cp ~/.config/i3/config dotfiles/i3_config 2>/dev/null
cp ~/.config/polybar/config.ini dotfiles/polybar_config.ini 2>/dev/null
cp ~/.config/picom/picom.conf dotfiles/picom.conf 2>/dev/null
cp ~/.config/kitty/kitty.conf dotfiles/kitty.conf 2>/dev/null

# 4. Inicializar Git
git init
git config --global user.name "$USER"
git config --global user.email "$EMAIL"
git add .
git commit -m "Initial commit: Arquitectura y Fix persistencia b43"

# 5. Conexión Remota
git branch -M main
git remote add origin https://github.com/$USER/$REPO.git

echo "✅ Estructura lista en ~/Proyectos/$REPO"
echo "🚀 Ahora ejecuta: git push -u origin main"
