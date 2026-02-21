#!/bin/bash
# =================================================================
# POST-INSTALL SCRIPT - DOTFILES & PERMISSIONS
# =================================================================

# Obtener la ruta real del script para no fallar con las rutas
BASE_DIR=$(cd "$(dirname "$0")/.." && pwd)

echo "🎨 Desplegando entorno gráfico..."

# Crear directorios de configuración
mkdir -p ~/.config/{i3,bspwm,sxhkd,picom,polybar,kitty}

# Copia selectiva de archivos desde el repositorio
if [ -d "$BASE_DIR/dotfiles" ]; then
    cp -rv "$BASE_DIR/dotfiles/"* ~/.config/
    echo "✅ Dotfiles copiados correctamente."
else
    echo "❌ Error: Carpeta dotfiles no encontrada en $BASE_DIR"
    exit 1
fi

# Permisos de ejecución críticos
chmod +x ~/.config/bspwm/bspwmrc 2>/dev/null || true
chmod +x ~/.config/polybar/launch.sh 2>/dev/null || true
chmod +x ~/.config/i3/config 2>/dev/null || true

# Añadir usuario al grupo video para control de brillo
sudo usermod -aG video $USER

echo "✨ Configuración finalizada con éxito."
echo "🔄 Por favor, REINICIA el MacBook para aplicar los cambios de Wi-Fi."
