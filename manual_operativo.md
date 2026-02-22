# 📖 Manual Operativo - MacBook Debian Security Lab

## 🧠 Decisiones Técnicas
* **Base:** Debian 12 (Bookworm) por estabilidad y compatibilidad con drivers non-free.
* **Window Manager:** `bspwm` + `sxhkd`. Estructura binaria para máxima eficiencia de pantalla y control total por teclado.
* **Hardware:** Uso de `mbpfan` para control de temperatura en MacBook y `tlp` para optimización de batería.
* **Networking:** Interfaces fijas en scripts: `wlan0` (Wi-Fi) y `enp3s0` (Ethernet).
* **Seguridad:** Implementación de "Physical Key" mediante UUID de tarjeta SD y comando `nuke` para borrado forense.

## 🗺️ Roadmap de Desarrollo
- [x] **Fase 1: Core.** Instalación, drivers de red y entorno gráfico funcional.
- [x] **Fase 2: Fortificación.** Script de instalación automática y seguridad física (SD Lock).
- [ ] **Fase 3: Pentesting Automático.** Scripts de recon automático y listeners preconfigurados.
- [ ] **Fase 4: Cloud Sync.** Backup cifrado automático de archivos de auditoría.

## 🛡️ Protocolo de Emergencia: Bypass de Llave SD
Si pierdes la tarjeta SD:
1. Arranca desde un **USB Live**.
2. Monta tu disco: `sudo mount /dev/sda2 /mnt` (ajusta la partición).
3. Elimina el bloqueo: `sudo rm /mnt/etc/systemd/system/keycheck.service`.
4. Reinicia.

## 🛠️ Comandos Propios
- `settarget <IP>`: Define la IP objetivo en Polybar.
- `cleartarget`: Limpia el objetivo actual.
- `burpsuite`: Lanza la suite de hacking desde cualquier terminal.
- `backup_repo`: Alias para subir cambios rápidos a GitHub.
