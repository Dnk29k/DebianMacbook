# =============================================================
#  .zshrc — MacBook Debian Tactical Workstation
#  Limpio, sin duplicados, rutas portables con $HOME
#  Actualizado: 2026-04-26
# =============================================================

# --- Powerlevel10k: instant prompt (debe ir al inicio) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================
# TEMA
# =============================================================
source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"

# =============================================================
# PLUGINS ZSH
# =============================================================
[[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -f /usr/share/zsh-sudo/sudo.plugin.zsh ]] && \
    source /usr/share/zsh-sudo/sudo.plugin.zsh

# =============================================================
# HISTORIAL
# =============================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt histignorealldups sharehistory
# OPSEC: no guardar comandos con espacio inicial ni duplicados
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_NO_STORE

# =============================================================
# COMPLETADO
# =============================================================
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'especifica: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completando %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: TAB para más%s'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt '%SScrolling: selección en %p%s'
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# =============================================================
# PATH
# =============================================================
export PATH="$HOME/.local/bin:/opt/kitty/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/opt/nvim/nvim-linux-x86_64/bin"

# =============================================================
# COLORES LS
# =============================================================
export LS_COLORS="rs=0:di=34:ln=36:mh=00:pi=40;33:so=35:do=35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=32:*.tar=31:*.tgz=31:*.zip=31:*.gz=31:*.bz2=31:*.jpg=35:*.jpeg=35:*.png=35:*.gif=35:*.svg=35:*.mp4=35:*.mkv=35:*.mp3=36:*.flac=36:*.ogg=36:*.bak=00;90:*.tmp=00;90:*.log=00;90:"

# =============================================================
# ALIASES — SISTEMA
# =============================================================
# bat (mejor cat)
alias cat='bat'
alias catn='bat --style=plain'
alias catnp='bat --style=plain --paging=never'

# lsd (mejor ls)
alias ls='lsd --group-dirs=first'
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias l='lsd --group-dirs=first'

# editor
alias v='nvim'
alias vi='nvim'

# sudo (permite aliases con sudo)
alias sudo='sudo '

# sistema
alias updatedb='sudo /usr/local/bin/updatedb-wrapper 2>/dev/null || sudo updatedb'
alias cls='clear'
alias reload='source ~/.zshrc'

# =============================================================
# ALIASES — HACKING / HTB
# =============================================================
alias htbcon='sudo openvpn $HOME/ovpn/dnk29.ovpn'
alias htbdes='sudo killall openvpn'
alias myip='ip -o -4 addr show | awk '"'"'{print $2, $4}'"'"''
alias ports='ss -tulnp'
alias listening='ss -tulnp | grep LISTEN'

# =============================================================
# ALIASES — VPN NORDVPN
# =============================================================
alias vpn-stat='nordvpn status'
alias vpn-on='nordvpn connect'
alias vpn-off='nordvpn disconnect'
alias vpn-es='nordvpn connect Spain'

# =============================================================
# ALIASES — HERRAMIENTAS PENTESTING
# =============================================================
alias burpsuite='/usr/local/bin/burpsuite'
alias bp='burpsuite &>/dev/null &'

# =============================================================
# FUNCIONES — TARGET (para Polybar)
# =============================================================
function settarget() {
    if [[ $# -ne 2 ]]; then
        echo "Uso: settarget <IP> <NOMBRE>"
        return 1
    fi
    mkdir -p "$HOME/.config/bin"
    echo "$1 $2" > "$HOME/.config/bin/target"
    echo "✓ Target: $1 — $2"
}

function cleartarget() {
    echo '' > "$HOME/.config/bin/target"
    echo "✓ Target eliminado"
}

alias target='cat $HOME/.config/bin/target 2>/dev/null | awk "{print \$1}"'
alias target-name='cat $HOME/.config/bin/target 2>/dev/null | awk "{print \$2}"'

# =============================================================
# FUNCIONES — UTILIDADES
# =============================================================

# Extraer cualquier comprimido
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"    ;;
            *.tar.gz)   tar xzf "$1"    ;;
            *.tar.xz)   tar xJf "$1"    ;;
            *.bz2)      bunzip2 "$1"    ;;
            *.rar)      unrar x "$1"    ;;
            *.gz)       gunzip "$1"     ;;
            *.tar)      tar xf "$1"     ;;
            *.tbz2)     tar xjf "$1"    ;;
            *.tgz)      tar xzf "$1"    ;;
            *.zip)      unzip "$1"      ;;
            *.Z)        uncompress "$1" ;;
            *.7z)       7z x "$1"       ;;
            *)          echo "'$1' no se puede extraer" ;;
        esac
    else
        echo "'$1' no es un archivo válido"
    fi
}

# mkcd — crear carpeta y entrar
mkcd() { mkdir -p "$1" && cd "$1"; }

# Buscar proceso por nombre
psgrep() { ps aux | grep -v grep | grep "$1"; }

# IP pública
pubip() { curl -s https://ipinfo.io/ip; echo; }

# =============================================================
# OLLAMA + CLAUDE CODE
# =============================================================
# GPU legacy NVIDIA 320M — forzar CPU para evitar warning de drivers
export OLLAMA_NUM_GPU_LAYERS=0
export OLLAMA_DEBUG=0

# Claude Code apunta a Ollama local
export ANTHROPIC_BASE_URL="http://localhost:11434/v1"
export ANTHROPIC_MODEL="kimi-k2.5:cloud"

# Función para lanzar el agente en el directorio actual
agent() {
    local model="${1:-kimi-k2.5:cloud}"
    echo "Lanzando agente Claude Code con modelo: $model"
    claude --model "$model"
}

# =============================================================
# AUTOSTART X11 (solo en TTY1, sin display activo)
# =============================================================
if [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]]; then
    sleep 1 && exec startx
fi

# =============================================================
# POWERLEVEL10K — configuración personalizada
# =============================================================
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
