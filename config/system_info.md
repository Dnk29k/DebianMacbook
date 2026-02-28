# 🖥️ Configuración de Hardware (Macbook-Debian)

## 🌐 Red (Interfaces)
- **WiFi**: wlan0
- **Ethernet**: enp3s0
- *Nota: Configurado en Polybar con iconos Nerd Fonts.*

## 🛡️ Herramientas
- **BurpSuite**: Fix de symlink manual.
  - Comando: sudo ln -sf /opt/BurpSuiteCommunity/BurpSuiteCommunity /usr/local/bin/burpsuite

### 🆘 Plan B Certificado Burp
- Si http://burp falla, usar http://127.0.0.1:8080
- Si sigue fallando, exportar DER desde Proxy > Proxy Settings > Import/Export CA.

## ⚠️ Errores de Hardware Detectados
- **GPU**: Driver 'nouveau' da fallos MMIO. Posible necesidad de drivers NVIDIA privativos o deshabilitar GPU dedicada.
- **Audio**: Pulseaudio falla al intentar cargar desde root (carpeta /nonexistent).
