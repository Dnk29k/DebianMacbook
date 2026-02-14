# ⚙️ Justificación de Decisiones Técnicas

1. **systemd vs /etc/modules:** Históricamente, `/etc/modules` cargaba los módulos. En arquitecturas modernas, `systemd-modules-load.service` dicta el orden de carga temprano. Usar `/etc/modules-load.d/b43.conf` garantiza que el kernel levante la antena antes de que NetworkManager intente escanear redes.
2. **Kitty sobre emuladores estándar:** Al ser hardware antiguo, delegar el renderizado de la terminal (fuentes con ligaduras de Hack Nerd Font) a la GPU mediante Kitty evita cuellos de botella en la CPU que otros emuladores basados en VTE (como el de GNOME o XFCE) generarían.
3. **Parámetros modprobe (`pio=1 qos=0`):** El chip Broadcom sufre de desbordamiento de buffer de hardware en Debian moderno. Desactivar Quality of Service (`qos=0`) e forzar Programmed I/O (`pio=1`) estabiliza la transmisión a costa de una pérdida teórica marginal de velocidad punta.
