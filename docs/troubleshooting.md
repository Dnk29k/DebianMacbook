# 🗺️ Hoja de Ruta Cronológica y Fases de Construcción

## FASE 1: Transición de Entorno (VM vs Bare Metal)

- **El Problema:** El desarrollo inicial se hizo en VMware (Parrot OS + bspwm). Al pasar a hardware real (MacBook Pro), las abstracciones de red y video de la VM desaparecen, exponiendo conflictos de hardware propietario.
- **Solución Adoptada:** Migración a Debian 12 (mayor control sobre paquetes base) y transición a i3wm para simplificar el árbol de dependencias gráficas durante el debug de hardware.

## FASE 2: Conflicto de Red Inalámbrica (BCM4322)

- **El Problema:** El hardware Apple utiliza chips Broadcom. El driver propietario moderno (`broadcom-sta-dkms` / `wl`) genera un error `22` de escaneo en este chip específico.
- **Intento Fallido:** Instalar el firmware heredado (`b43`) y añadirlo a `/etc/modules`. Funcionaba temporalmente, pero al reiniciar, la interfaz `wlan0` desaparecía.
- **Solución Adoptada:** 1. Purga total del driver `wl`.
2. Destrucción de bloqueos heredados en `/etc/modprobe.d/` [cite: 2026-02-13].
3. Delegar la carga del módulo a `systemd` (`/etc/modules-load.d/`).

## FASE 3: Aceleración Gráfica y Compositor

- **El Problema:** En VMware, usar renderizado OpenGL (`glx`) en Picom causa crashes; se requiere `xrender`. Sin embargo, en bare-metal, `xrender` causa *screen tearing* (cortes de pantalla) y alto uso de CPU.
- **Solución Adoptada:** Forzar `backend = "glx"` y `vsync = true` en hardware real para delegar el dibujado a la GPU del Mac, liberando la CPU.
