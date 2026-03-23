# 💻 MacBook-Debian: Secure Tactical Workstation

![Debian](https://img.shields.io/badge/OS-Debian%2012-blue?logo=debian)
![Hardware](https://img.shields.io/badge/Hardware-MacBook%20Pro%202010-lightgrey?logo=apple)
![Security](https://img.shields.io/badge/Security-Physical%20Key%20Active-red)

Entorno de trabajo minimalista y fortificado, optimizado específicamente para el hardware de Apple (chipset Nvidia MCP89) y diseñado para tareas de seguridad ofensiva, auditoría de redes y privacidad absoluta.

---

## 🛡️ Características de Seguridad de Nivel Forense

Este sistema implementa capas de seguridad que van más allá del software tradicional:

* **Physical Key Lock (SD-AUTH):** El arranque está condicionado a una tarjeta SD autorizada (UUID). Si no coincide, el sistema ejecuta un `poweroff` inmediato mediante un servicio de Systemd (`check_key.sh`).
* **Panic Button (Nuke Script):** Comando integrado para la destrucción rápida de sesiones, historial y archivos temporales mediante sobreescritura `shred`.
* **Encrypted Workflow:** Preparado para el manejo de herramientas de pentesting sin persistencia de datos sensibles en el almacenamiento local.

---

## 🛠️ Arsenal de Comandos y Protocolos OPSEC

### 🛡️ 1. Killswitch Táctico (`vpn_lock.sh`)
* **¿Qué es?**: Cortafuegos estricto basado en `ufw` que bloquea todo tráfico fuera del túnel `tun0`.
* **Comandos**:
    * `vpn-on`: Cierra el perímetro. Si la VPN cae, el tráfico se corta.
    * `vpn-off`: Abre el perímetro para actualizaciones de sistema.

### 🥷 2. Modo Fantasma (ZSH Stealth)
* **Configuración**: `setopt HIST_IGNORE_SPACE` activo.
* **Uso**: Añade un **espacio en blanco** antes de cualquier comando con IPs o contraseñas para que NO se guarde en `.zsh_history`.

### 🎭 3. Ofuscación de Hardware (MAC Spoofing)
* Cambio aleatorio de direcciones MAC para `wlan0` y `enp3s0` en cada conexión, evitando el rastreo físico del MacBook en redes locales.

---

## 🍏 Hardware & Fixes Específicos (MacBook Pro 2010)

Para garantizar la **estabilidad y eficacia**, se han aplicado los siguientes parches:

* **Wi-Fi Broadcom (b43 vs wl):** Blacklist activa para evitar conflictos de firmware.
    * `echo "blacklist b43" > /etc/modprobe.d/blacklist.conf`
* **Nvidia MCP89:** Optimización de renderizado en **Kitty** para latencia cero.
* **Burp Suite Symlink:** Acc
