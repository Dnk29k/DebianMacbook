# 💻 MacBook-Debian 12: Entorno de Auditoría
Repositorio de configuración optimizado para MacBook Pro con Debian 12 (Bookworm), enfocado en ciberseguridad y personalización estética.

## 🚀 Configuración de Red e Interfaz
El sistema utiliza **Polybar** con iconos de **Nerd Fonts** para feedback visual inmediato del estado de las interfaces:
- **WiFi:** `wlan0` (Driver b43 optimizado).
- **Ethernet:** `enp3s0`.
- **Status:** Lógica `format-disconnected` implementada para monitorización en tiempo real.

## 🎯 Workflow de Auditoría (Target to Hack)
Sistema automatizado para visualizar el objetivo actual en la Polybar.
- `settarget <IP> <Nombre>`: Establece el objetivo (escribe en `~/.config/bin/target`).
- `cleartarget`: Limpia el objetivo actual.
- **Script de visualización:** `target_to_hack.sh` procesa los datos y aplica colores Neón (Rojo/Blanco).

## 🔧 Fixes Importantes Aplicados
- **Burp Suite:** Symlink manual creado en `/usr/local/bin/burpsuite` -> `/opt/BurpSuiteCommunity/`.
- **Sincronización de Root:** La `.zshrc` de `root` apunta mediante un link a la de `dnk29`, permitiendo compartir alias y funciones de auditoría.
- **Network Blacklist:** Gestión de módulos para evitar conflictos con el driver `b43`.

## ⌨️ Comandos Rápidos
- `v`: Alias para Neovim.
- `ls`: Configurado con `lsd` para iconos.
- **Gestor de Ventanas:** `bspwm` + `sxhkd` (Configuración de teclas en el repo).
