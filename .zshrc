# Path configuration
export PATH="/home/denis/.local/bin:$PATH"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Disable default theme since we define custom PROMPT
ZSH_THEME=""

# Plugins
plugins=(
    git
    sudo
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# -----------------------------------------------------------------------------
# History Settings (Мгновенная синхронизация между всеми терминалами)
# -----------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=200000
setopt SHARE_HISTORY          # Мгновенно делиться историей между всеми окнами/вкладками
setopt HIST_IGNORE_ALL_DUPS   # Не сохранять дубликаты
setopt HIST_IGNORE_SPACE      # Не сохранять команды с пробелом в начале
setopt HIST_SAVE_NO_DUPS      # Не сохранять дубликаты в файл
setopt HIST_EXPIRE_DUPS_FIRST # Удалять дубликаты первыми при переполнении
setopt HIST_FIND_NO_DUPS      # При поиске показывать уникальные записи

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
alias ls='ls --color=auto'
alias ll='eza -lah --time created --icons'
alias la='eza -a --icons'
alias lt='eza --tree --level=2 --icons'
alias cat='bat'
alias grep='grep --color=auto'

# -----------------------------------------------------------------------------
# Catppuccin Mocha Colors & Welcome Banner
# -----------------------------------------------------------------------------
__show_greeting() {
    local hour
    hour=$(date +%H)
    local greeting="Добро пожаловать"
    if [ "$hour" -ge 5 ] && [ "$hour" -lt 12 ]; then
        greeting="Доброе утро"
    elif [ "$hour" -ge 12 ] && [ "$hour" -lt 18 ]; then
        greeting="Добрый день"
    elif [ "$hour" -ge 18 ] && [ "$hour" -lt 23 ]; then
        greeting="Добрый вечер"
    else
        greeting="Доброй ночи"
    fi

    local e_blue=$'\e[38;2;137;180;250m'
    local e_mauve=$'\e[38;2;203;166;247m'
    local e_peach=$'\e[38;2;250;179;135m'
    local e_green=$'\e[38;2;166;227;161m'
    local e_teal=$'\e[38;2;148;226;213m'
    local e_gray=$'\e[38;2;108;112;134m'
    local e_sub=$'\e[38;2;166;173;200m'
    local e_bold=$'\e[1m'
    local e_reset=$'\e[0m'

    print ""
    print "  ${e_mauve}${e_reset}  ${e_bold}${e_blue}Arch Linux${e_reset} ${e_gray}•${e_reset} ${e_teal}Hyprland${e_reset} ${e_gray}•${e_reset} ${e_peach}Kitty / Zsh${e_reset}"
    print "  ${e_green}󰄛 ${greeting}, ${USER}!${e_reset}  ${e_sub}󰥔 $(date +%H:%M)${e_reset}  ${e_gray}󰃭 $(date +%d.%m.%Y)${e_reset}"
    print ""
}

__show_greeting

# -----------------------------------------------------------------------------
# Dynamic Catppuccin Prompt (Чистые Zsh 24-bit TrueColor коды)
# -----------------------------------------------------------------------------
__git_branch_zsh() {
    local branch
    branch=$(git branch --show-current 2>/dev/null || git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        local dirty=""
        local color="%F{#cba6f7}" # Mauve
        if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
            dirty="*"
            color="%F{#f9e2af}" # Yellow
        fi
        print -n " ${color} ${branch}${dirty}%f"
    fi
}

setopt PROMPT_SUBST

PROMPT='%F{#6c7086}╭─ %F{#89b4fa} %~%f$(__git_branch_zsh)
%F{#6c7086}╰─%(?.%F{#a6e3a1}.%F{#f38ba8})❯%f '

# -----------------------------------------------------------------------------
# Keybindings for Autosuggestions & History Search
# -----------------------------------------------------------------------------
# Стрелка вверх/вниз для поиска по началу введенной команды
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Стрелка вправо — принять автодополнение
bindkey '^[[C' forward-char

# Rust cargo env
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Dotfiles bare git alias
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
