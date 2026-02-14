Hoja de Ruta Técnica

## FASE 0 – Punto de partida

Sistema recién instalado (Parrot/Debian).
Entorno gráfico funcional pero pesado o inestable.
VMware con aceleración gráfica problemática.

---

## FASE 1 – Base del sistema

### Problema

Debian/Parrot bloquean firmware privativo por defecto.
Esto rompe Wi-Fi, GPU y dispositivos Apple.

### Solución

Habilitar:

- contrib
- non-free
- non-free-firmware

Esto **no es opcional** en hardware real ni VM.

---

## FASE 2 – El Wi-Fi que muere tras reiniciar (Broadcom b43)

### Síntoma

- Wi-Fi funciona tras instalar firmware
- Desaparece tras apagar/reiniciar

### Causa real

- `b43` está en blacklist
- `broadcom-sta-dkms` entra en conflicto
- El módulo no se carga en el arranque
- initramfs no contiene el driver

### Soluciones comunes que FALLAN

- Reinstalar firmware
- Reiniciar NetworkManager
- `modprobe b43` manual

### Solución definitiva (blindaje)

1. Purgar driver conflictivo
2. Neutralizar TODAS las blacklists
3. Forzar carga con `modules-load.d`
4. Ajustar opciones de estabilidad
5. Regenerar initramfs

Esto garantiza **persistencia tras reinicio**.

---

## FASE 3 – Entorno gráfico minimalista

### Decisión

bspwm en lugar de entornos completos.

### Motivo

- Control total
- Menor consumo
- Predecible
- Depurable

---

## FASE 4 – Picom y el infierno gráfico en VMware

### Síntomas reales

- GLX activo pero sin aceleración
- EGL falla
- VMware usa renderizado software
- Picom se cuelga con blur y sombras

### Decisión crítica

👉 **xrender** como backend

No es bonito.
Es estable.
Es rápido.
No se congela.

---

## FASE 5 – Blindaje final

- systemd
- initramfs
- permisos de vídeo
- rfkill
- arranque limpio

**📄 docs/decisiones-tecnicas.md**

Decisiones Técnicas Clave

## ¿Por qué xrender y no glx?

Porque VMware reporta GLX pero **no acelera**.
GLX + picom = software rendering + stutter.

xrender:

- No depende de GPU real
- Predecible
- Estable

## ¿Por qué modules-load.d?

Porque `modprobe` manual NO sobrevive reinicios.
systemd es quien manda al arrancar.

## ¿Por qué regenerar initramfs?

Si el driver no está en initramfs:

- El kernel arranca sin él
- El Wi-Fi aparece tarde o nunca
