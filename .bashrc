#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Path configuration
export PATH="/home/denis/.local/bin:$PATH"

# -----------------------------------------------------------------------------
# History Settings (Sync between multiple terminals)
# -----------------------------------------------------------------------------
shopt -s histappend                        # Дописывать в историю, а не перезаписывать файл
export HISTSIZE=100000                     # Количество строк в памяти
export HISTFILESIZE=200000                 # Количество строк в файле ~/.bash_history
export HISTCONTROL=ignoreboth:erasedups    # Игнорировать пробелы и дубликаты
export HISTTIMEFORMAT="%d.%m.%Y %H:%M:%S " # Запоминать время выполнения команд


# Aliases
alias ls='ls --color=auto'
alias ll='eza -lah --time created --icons'
alias la='eza -a --icons'
alias lt='eza --tree --level=2 --icons'
alias cat='bat'
alias grep='grep --color=auto'

# -----------------------------------------------------------------------------
# Catppuccin Mocha Colors & Styles
# -----------------------------------------------------------------------------
C_BLUE="\[\033[38;2;137;180;250m\]"
C_MAUVE="\[\033[38;2;203;166;247m\]"
C_PEACH="\[\033[38;2;250;179;135m\]"
C_GREEN="\[\033[38;2;166;227;161m\]"
C_RED="\[\033[38;2;243;139;168m\]"
C_YELLOW="\[\033[38;2;249;226;175m\]"
C_TEAL="\[\033[38;2;148;226;213m\]"
C_GRAY="\[\033[38;2;108;112;134m\]"
C_SUB="\[\033[38;2;166;173;200m\]"
C_BOLD="\[\033[1m\]"
C_RESET="\[\033[0m\]"

# -----------------------------------------------------------------------------
# Welcome Greeting Banner (Строка приветствия при запуске)
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

    # Raw escape colors for echo
    local e_blue="\033[38;2;137;180;250m"
    local e_mauve="\033[38;2;203;166;247m"
    local e_peach="\033[38;2;250;179;135m"
    local e_green="\033[38;2;166;227;161m"
    local e_teal="\033[38;2;148;226;213m"
    local e_gray="\033[38;2;108;112;134m"
    local e_sub="\033[38;2;166;173;200m"
    local e_bold="\033[1m"
    local e_reset="\033[0m"

    echo -e ""
    echo -e "  ${e_mauve}${e_reset}  ${e_bold}${e_blue}Arch Linux${e_reset} ${e_gray}•${e_reset} ${e_teal}Hyprland${e_reset} ${e_gray}•${e_reset} ${e_peach}Kitty${e_reset}"
    echo -e "  ${e_green}󰄛 ${greeting}, ${USER}!${e_reset}  ${e_sub}󰥔 $(date +%H:%M)${e_reset}  ${e_gray}󰃭 $(date +%d.%m.%Y)${e_reset}"
    echo -e ""
}

# Display greeting
__show_greeting

# -----------------------------------------------------------------------------
# Git Branch Info in Prompt
# -----------------------------------------------------------------------------
__git_prompt() {
    local branch
    branch=$(git branch --show-current 2>/dev/null || git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        local dirty=""
        local color="\[\033[38;2;203;166;247m\]" # Mauve
        if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
            dirty="*"
            color="\[\033[38;2;249;226;175m\]" # Yellow if modified
        fi
        printf " ${color} %s%s\[\033[0m\]" "$branch" "$dirty"
    fi
}

# -----------------------------------------------------------------------------
# Dynamic Prompt (Строка приглашения PS1)
# -----------------------------------------------------------------------------
__set_prompt() {
    local last_exit=$?
    local symbol_color
    if [ "$last_exit" -eq 0 ]; then
        symbol_color="\[\033[38;2;166;227;161m\]" # Green
    else
        symbol_color="\[\033[38;2;243;139;168m\]" # Red on error
    fi

    local git_info
    git_info=$(__git_prompt)

    PS1="${C_GRAY}╭─ ${C_BLUE} \w${C_RESET}${git_info}\n${C_GRAY}╰─${symbol_color}❯${C_RESET} "
}

__prompt_command() {
    history -a  # Сразу дописывать выполненную команду в ~/.bash_history
    history -c  # Очистить буфер памяти
    history -r  # Перечитать весь файл истории (включая команды из соседних терминалов)
    __set_prompt
}

PROMPT_COMMAND=__prompt_command
. "$HOME/.cargo/env"

# Dotfiles bare git alias
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
