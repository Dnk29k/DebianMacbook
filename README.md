# 💻 MacBook Pro 2010-2012: Debian 12 Optimization Suite

![Debian](https://img.shields.io/badge/OS-Debian%2012-red?logo=debian) ![i3wm](https://img.shields.io/badge/WM-i3wm-blue) ![Hardware](https://img.shields.io/badge/Hardware-Apple%20MacBook%20Pro-silver)

## 📖 Introducción
Este proyecto documenta la reconstrucción total de un MacBook Pro bajo Debian 12, priorizando el rendimiento y la estabilidad del hardware. No se trata de una simple personalización estética; es una solución de infraestructura que resuelve problemas críticos de controladores Broadcom y persistencia de módulos del kernel.

---

## 🗺️ Hoja de Ruta Técnica (Roadmap)

### Fase 1: Diagnóstico y Drivers
* **El Problema:** El hardware de Apple usa chips Broadcom que suelen entrar en conflicto con el driver genérico `wl`. Esto genera el **Error -22** y fallos de escaneo.
* **La Solución:** Implementar el firmware `b43` heredado, optimizado con parámetros de estabilidad (`pio=1 qos=0`).

### Fase 2: Blindaje de Persistencia (Anti-Amnesia)
* **El Problema:** El Wi-Fi funciona en la sesión actual pero desaparece al reiniciar.
* **La Causa:** Directivas `blacklist b43` ocultas en `/etc/modprobe.d/` y falta de carga temprana en `systemd` [cite: 2026-02-13].
* **La Solución:** Auditoría y purga de listas negras mediante scripts automáticos y registro del módulo en `modules-load.d` [cite: 2026-02-13].

### Fase 3: Entorno Gráfico Minimalista
* **Arquitectura:** i3wm (Window Manager) + Polybar (Estado) + Picom (Compositor).
* **Optimización:** Uso de backend `glx` en Picom para delegar el dibujado a la GPU del MacBook, eliminando el uso innecesario de CPU.

---

## 🛠️ Registro de Troubleshooting (Depuración)

| Error Detectado | Causa Raíz | Solución Técnica |
| :--- | :--- | :--- |
| **Interfaz wlan0 ausente** | Blacklist activa en el kernel | `sed -i` para comentar bloqueos en `/etc/modprobe.d/` [cite: 2026-02-13] |
| **Carga manual necesaria** | Módulo no indexado en el arranque | Creación de `/etc/modules-load.d/b43.conf` [cite: 2026-02-13] |
| **Screen Tearing** | Backend xrender insuficiente | Migración a Backend `glx` con VSync activo |
| **Iconos rotos** | Falta de glifos en sistema | Instalación de `Hack Nerd Font` y configuración en Kitty/Polybar |

---

## 🚀 Guía de Despliegue (Instrucciones)

> **Importante:** Estos comandos están diseñados para ser ejecutados en una instalación limpia.

### 1. Clonar e Inicializar
```bash
git clone [https://github.com/Dnk29k/DebianMacbook.git](https://github.com/Dnk29k/DebianMacbook.git)
cd DebianMacbook


2. Ejecutar Setup de Sistema

Instala dependencias, repositorios non-free y entorno gráfico:

chmod +x scripts/setup.sh
./scripts/setup.sh

3. Aplicar Blindaje de Hardware

Este paso es obligatorio para garantizar que el Wi-Fi sobreviva al reinicio [cite: 2026-02-13]:

chmod +x scripts/post-install.sh
./scripts/post-install.sh

⚙️ Decisiones Técnicas Destacadas

    Persistencia b43: Se forzó la carga del módulo mediante systemd para asegurar que el hardware esté disponible antes de que NetworkManager inicie el escaneo.

    Kitty Terminal: Configurada con aceleración por hardware (GPU) y tipografía Hack Nerd Font para una experiencia fluida y con soporte total de iconos.

    Clean Blacklist: El script de post-instalación realiza una limpieza profunda de cualquier archivo que intente silenciar la antena Broadcom [cite: 2026-02-13].



