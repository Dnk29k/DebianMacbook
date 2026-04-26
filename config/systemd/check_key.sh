#!/bin/bash
# =============================================================
# check_key.sh — SD-AUTH Validation for MacBook Pro 7,1
# Versión: 2.1 — Compatible con SKIP_SD_AUTH para migración
# =============================================================
set -euo pipefail

# --- Configuración ---
KEY_FILE="/usr/local/etc/key_data"
SD_DEVICE="/dev/mmcblk0p1"
LOG_TAG="check_key"

# --- 🔓 Bypass seguro para migraciones/mantenimiento ---
if [[ "${SKIP_SD_AUTH:-0}" == "1" ]]; then
  logger -t "$LOG_TAG" "[INFO] SD-AUTH bypassed via SKIP_SD_AUTH=1 (Migration/Maintenance mode)"
  exit 0
fi

# --- Pre-flight checks ---
if [[ ! -f "$KEY_FILE" ]]; then
  logger -t "$LOG_TAG" "[CRITICAL] Key file missing: $KEY_FILE"
  exit 1
fi

if ! command -v blkid &>/dev/null; then
  logger -t "$LOG_TAG" "[ERROR] blkid not found. Aborting validation."
  exit 1
fi

# --- Validación de UUID ---
EXPECTED_UUID="$(cat "$KEY_FILE" | tr -d '[:space:]')"
CURRENT_UUID="$(blkid -s UUID -o value "$SD_DEVICE" 2>/dev/null || echo "NONE")"

if [[ "$CURRENT_UUID" != "$EXPECTED_UUID" ]]; then
  logger -t "$LOG_TAG" "[SECURITY] UUID mismatch! Expected: $EXPECTED_UUID | Found: $CURRENT_UUID"
  logger -t "$LOG_TAG" "[ACTION] Initiating secure shutdown..."
  # Descomenta la siguiente línea si quieres apagado automático ante fallo:
  # shutdown -h now "SD-AUTH validation failed"
  exit 1
fi

logger -t "$LOG_TAG" "[OK] SD-AUTH verified successfully"
exit 0
