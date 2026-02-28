# ⌨️ Neovim Cheatsheet (Macbook-Debian)

## 🚀 Comandos de Sistema (Sudo)
- `snvim <archivo>`: Abrir con privilegios de root usando MI configuración (vía sudoedit).
- `sudo nvim`: Neovim con privilegios totales (enlace simétrico con dnk29).

## 🧩 Gestión de Plugins (Mason & Lazy)
- `:Mason`: Abrir el gestor de LSPs, Linters y Formatters.
- `:Lazy`: Ver estado de los plugins y actualizar.
- `:MasonUpdate`: Actualizar todos los paquetes de Mason.

## 📂 Navegación y Archivos
- `<leader> e`: Abrir explorador de archivos (NvimTree).
- `<leader> ff`: Buscar archivos (Telescope).
- `<leader> fw`: Buscar texto en todo el proyecto (Live Grep).
- `<leader> fb`: Ver buffers abiertos.

## 🛠️ Edición Avanzada
- `gcc`: Comentar/Descomentar una línea.
- `ga`: Ver el código ASCII del carácter bajo el cursor.
- `:w!`: Forzar guardado.
- `:q!`: Salir sin guardar (fuerza bruta).

## 💡 Atajos de Terminal
- `<leader> h`: Abrir terminal horizontal.
- `<leader> v`: Abrir terminal vertical.
- `Esc` (en terminal): Volver al modo normal.
- `./setup_env.sh`: Reinstalar todo mi entorno de Rofi, sxhkd y temas.
