# 💻 MacBook-Debian: Secure Tactical Workstation

![Debian](https://img.shields.io/badge/OS-Debian%2012-blue?logo=debian)
![Hardware](https://img.shields.io/badge/Hardware-MacBook%20Pro%202010-lightgrey?logo=apple)
![Security](https://img.shields.io/badge/Security-Physical%20Key%20Active-red)

Entorno de trabajo minimalista y fortificado, optimizado específicamente para el hardware de Apple (chipset Nvidia MCP89) y diseñado para tareas de seguridad ofensiva y privacidad.



## 🛡️ Características de Seguridad de Nivel Forense

Este sistema implementa capas de seguridad que van más allá del software tradicional:

* **Physical Key Lock (SD-AUTH):** El arranque del sistema está condicionado a la presencia de una tarjeta SD autorizada. Si el UUID no coincide al inicio, el sistema ejecuta un `poweroff` inmediato antes de exponer cualquier dato o pantalla de login.
* **Panic Button (Nuke Script):** Comando integrado para la destrucción rápida de sesiones, historial de terminal y archivos temporales de auditoría mediante sobreescritura `shred`.
* **Encrypted Workflow:** Preparado para el manejo de herramientas de pentesting sin dejar rastro en el almacenamiento local.

## ⚙️ Especificaciones del Entorno

* **Window Manager:** `bspwm` (Tiling Window Manager para máxima eficiencia).
* **Hotkeys:** Gestionados con `sxhkd` para un flujo de trabajo 100% teclado.
* **Terminal:** `Kitty` (Renderizado por GPU para latencia cero).
* **Barra de Estado:** `Polybar` con módulos dinámicos de red (`wlan0`/`enp3s0`) y objetivos de hacking.
* **Shell:** `ZSH` con integración total entre usuario y root.

## 🚀 Despliegue Rápido (Quick Setup)

Si acabas de instalar Debian 12 limpio en tu MacBook:

```bash
# 1. Clonar el arsenal
git clone [https://github.com/dnk29k/DebianMacbook.git](https://github.com/dnk29k/DebianMacbook.git)
cd DebianMacbook

# 2. Dar permisos al instalador
chmod +x install.sh

# 3. Ejecutar el despliegue automático
./install.sh
