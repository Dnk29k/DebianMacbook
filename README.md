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

## 🛠️ Arsenal de Comandos y Protocolos OPSEC

Este sistema no es una instalación estándar de Debian; es una estación fortificada. A continuación, los protocolos integrados:

### 🛡️ 1. Killswitch Táctico (`vpn_lock.sh`)
**El Escudo de Identidad.**
* **¿Qué es?**: Un cortafuegos estricto basado en `ufw` que bloquea todo tráfico que no pase por el túnel seguro (`tun0`).
* **¿Cuándo usarlo?**: **Obligatorio** antes de iniciar cualquier auditoría con OpenVPN (HackTheBox, TryHackMe, Clientes).
* **Comandos**:
    * `vpn-on`: Cierra el perímetro. Si la VPN se cae, internet se corta totalmente. Tu IP real nunca se filtrará.
    * `vpn-off`: Abre el perímetro para navegación normal y actualizaciones de sistema.

### 🔑 2. Llave Física de Arranque (`check_key.sh`)
**El Control de Acceso Físico.**
* **¿Qué es?**: Un servicio de Systemd que valida el UUID de una tarjeta SD específica durante el boot.
* **¿Cuándo usarlo?**: Se activa automáticamente. Sin la tarjeta SD insertada, el MacBook se apaga antes de llegar al login.
* **Protocolo**: Ideal para evitar que alguien ajeno encienda tu equipo. Una vez que el sistema ha arrancado, puedes retirar la tarjeta si necesitas el puerto.

### 🥷 3. Modo Fantasma en Terminal (ZSH Stealth)
**Protección de Evidencias Locales.**
* **¿Qué es?**: Configuración avanzada de `zsh` que ignora comandos sensibles.
* **¿Cómo usarlo?**: Simplemente añade un **espacio en blanco** antes de cualquier comando que contenga contraseñas, IPs o datos privados.
    * *Ejemplo*: ` nmap -sV 10.10.10.5` (Este comando NO aparecerá en tu historial al pulsar la flecha arriba ni en el archivo `.zsh_history`).

### 🎭 4. Ofuscación de Hardware (MAC Spoofing)
**Identidad de Capa 2.**
* **¿Qué es?**: Cambio aleatorio de la dirección MAC de `wlan0` y `enp3s0` mediante NetworkManager.
* **¿Cuándo usarlo?**: Siempre activo. Cada vez que te conectes a una red (pública o privada), tu MacBook se identificará con una dirección física distinta, haciendo imposible el rastreo de tu dispositivo por hardware.

### 🛠️ Notas de Instalación de Herramientas
* **Burp Suite**: Instalado en `/opt/BurpSuiteCommunity/`. Se requiere un symlink manual para ejecución global:
  `sudo ln -s /opt/BurpSuiteCommunity/BurpSuiteCommunity /usr/local/bin/burpsuite`
  (Gestionado automáticamente por `install_tools.sh`).

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
