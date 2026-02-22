# 📖 Manual Operativo: Ecosistema MacBook-Debian

Este documento explica la arquitectura, el flujo de trabajo y la lógica de automatización de este entorno. Está diseñado para asegurar la continuidad del laboratorio de auditoría incluso tras un formateo completo.

---

## 🏗️ 1. Arquitectura del Sistema (El Robot Constructor)

El núcleo de este repositorio es el script `install.sh`. Su función es transformar una instalación limpia de Debian 12 en una estación de trabajo de hacking funcional.

### ¿Qué hace exactamente el script de instalación?
1. **Aprovisionamiento de Software:** Instala el gestor de ventanas (`bspwm`), el gestor de atajos (`sxhkd`) y la barra de estado (`polybar`).
2. **Despliegue de "Dotfiles":** Copia las configuraciones personalizadas del repositorio a las carpetas ocultas del sistema (`~/.config`).
3. **Persistencia de Privilegios:** Vincula la configuración de la terminal (`.zshrc`) del usuario dnk29 con el usuario `root`. Esto permite que, al escalar privilegios, mantengas tus alias, funciones de auditoría y estética visual.
4. **Resolución de Conflictos (Fixes):**
   - Crea un **Enlace Simbólico (Symlink)** para Burp Suite, permitiendo lanzarlo con el comando `burpsuite` desde cualquier directorio.
   - Configura permisos de ejecución masivos para todos los scripts de automatización.

---

## 🎯 2. Gestión de Objetivos (Workflow de Auditoría)

El sistema utiliza un flujo de tres capas para monitorizar el objetivo (Target) en tiempo real:

1. **Capa de Entrada (Zsh):** La función `settarget` recibe la IP y el nombre.
   - *Comando:* `settarget 10.10.10.123 MaquinaHTB`
2. **Capa de Almacenamiento (Archivo):** La información se guarda de forma persistente en `~/.config/bin/target`.
3. **Capa de Visualización (Polybar):** El script `target_to_hack.sh` escanea ese archivo cada segundo. 
   - Si detecta datos, aplica etiquetas de formato de Polybar (`%{F#color}`) e iconos de **Nerd Fonts**.
   - Si está vacío, activa la lógica de "No target".



---

## 🌐 3. Configuración de Red y Hardware

Debido a las particularidades del hardware MacBook Pro, el sistema está preconfigurado para:
- **WiFi (`wlan0`):** Optimizado para el driver `b43`.
- **Ethernet (`enp3s0`):** Configurado para priorizar la estabilidad en escaneos de red pesados.
- **Feedback Visual:** La Polybar cambia de icono y color automáticamente si una interfaz cae o se desconecta.

---

## 🆘 4. Guía de Mantenimiento y Emergencias

### Sincronización con la Nube (Backup)
Para guardar cambios nuevos en el sistema y subirlos al manual:
```zsh
cp ~/.zshrc ~/DebianMacbook/          # Copiar cambios
cd ~/DebianMacbook && git add .       # Preparar
git commit -m "Actualización"         # Guardar
git push origin main                  # Subir
