# 🔄 Guía de Migración a SSD — MacBook Pro 7,1

> ⚠️ **Lee esto completo ANTES de empezar**. Tu sistema usa SD-AUTH: si los UUIDs cambian, no arrancará.

---

## 📋 Checklist Pre-Migración

```bash
# 1. En tu sistema actual, exporta UUIDs críticos
sudo blkid > ~/backup_uuids_$(date +%F).txt

# 2. Backup de key_data (si no está en el repo)
sudo cp /usr/local/etc/key_data ~/key_data.backup

# 3. Commit y push de cambios al repo
cd ~/DebianMacbook
git add .
git commit -m "Pre-migración: backup UUIDs y configs"
git push
