#!/bin/bash
SESSION="PHOENIX"
tmux kill-session -t $SESSION 2>/dev/null
tmux new-session -d -s $SESSION -n "HUD" 'btop'
tmux split-window -v -p 30
tmux split-window -h
tmux send-keys -t $SESSION:0.1 'tail -f /var/log/auth.log' C-m
# Monitorizando específicamente tu WiFi y Ethernet
tmux send-keys -t $SESSION:0.2 'watch -n 1 "ip a | grep -E \"tun0|wlan0|enp3s0\""' C-m
tmux attach-session -t $SESSION
