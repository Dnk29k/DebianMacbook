# 💻 MacBook Pro Debian 12 - Setup de Auditoría

Este repositorio contiene la configuración optimizada para mi MacBook Pro con Debian 12, enfocado en ciberseguridad y productividad. [cite: 2026-02-14, 2026-02-16]

## 🛠️ Especificaciones de Hardware y Red
* **Dispositivo:** MacBook Pro 2010. [cite: 2026-02-16]
* **Interfaz WiFi:** `wlan0`. [cite: 2026-02-17]
* **Interfaz Ethernet:** `enp3s0`. [cite: 2026-02-17]
* **Compositor:** `picom` (necesario para transparencias en Polybar). [cite: 2026-02-15]

## ⌨️ Guía de Atajos (Cheat Sheet)

### Neovim (NvChad v0.11.6)
* **Abrir editor:** Comando `v` (alias de `nvim`). [cite: 2026-02-15, 2026-02-19]
* **Explorador de archivos:** `Ctrl + n`. [cite: 2026-02-19]
* **Buscador (Telescope):** `Espacio + f + f`. [cite: 2026-02-19]
* **Terminal flotante:** `Alt + i`. [cite: 2026-02-19]
* **Temas:** `Espacio + t + h`. [cite: 2026-02-19]

### Sistema (bspwm + sxhkd)
* **Terminal:** `Super + Enter`. [cite: 2026-02-19]
* **Cerrar Ventana:** `Super + w`. [cite: 2026-02-19]
* **Cambiar Escritorio:** `Super + [1-9]`. [cite: 2026-02-19]
* **Reiniciar WM:** `Super + Alt + r`. [cite: 2026-02-19]

## 🎯 Funciones de Auditoría (Target System)
* `settarget <IP> <Nombre>`: Define el objetivo en la Polybar. [cite: 2026-02-15, 2026-02-19]
* `cleartarget`: Elimina el objetivo de la barra. [cite: 2026-02-19]
* **Interacción Polybar:** Click izquierdo para borrar, click derecho para copiar IP. [cite: 2026-02-19]

## 🩹 Soluciones a Problemas (Fixes)
* **BurpSuite:** Symlink manual en `/usr/local/bin/burpsuite` apuntando a `/opt/BurpSuiteCommunity/`. [cite: 2026-02-15]
* **Root Sync:** La `.zshrc` de root apunta a la de `dnk29` para mantener alias y funciones. [cite: 2026-02-15]
