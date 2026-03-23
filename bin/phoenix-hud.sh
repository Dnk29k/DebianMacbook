#!/bin/bash
SESSION="PHOENIX"

# Matar sesión previa
tmux kill-session -t $SESSION 2>/dev/null

# Crear sesión
tmux new-session -d -s $SESSION -n "HUD"

# --- ESTÉTICA TMUX (Bordes Rojos) ---
tmux set-option -t $SESSION pane-border-style fg="#222222"
tmux set-option -t $SESSION pane-active-border-style fg="#ff0000"

# PANEL 1: btop (Sin flags que rompan la versión de Debian)
tmux send-keys -t $SESSION:0.0 'btop' C-m

# Divisiones
tmux split-window -v -p 30 -t $SESSION
tmux split-window -h -t $SESSION

# PANEL 2: Logs
tmux send-keys -t $SESSION:0.1 'journalctl -f -n 20 --no-hostname' C-m

# PANEL 3: Red Ultra-Clean
tmux send-keys -t $SESSION:0.2 'watch -t -n 1 "ip -brief addr show | grep -E \"tun0|wlan0|enp3s0|ens33\" | awk '\''{print \$1, \"=>\", \$3}'\''"' C-m

tmux select-pane -t $SESSION:0.0
tmux attach-session -t $SESSION
