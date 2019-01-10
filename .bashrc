#
# ~/.bashrc
#

# If not running interactively, don't do anything
HISTSIZE= HISTFILESIZE=
[[ $- != *i* ]] && return

# VARS 
export EDITOR='vim'

if [ -f /usr/bin/chromium ]
    then export WEBBROWSER='chromium'
    else export WEBBROWSER='firefox'
fi

# load aliases
if [ -f ~/.bash_aliases ]
    then 
        source ~/.bash_aliases
    else
        echo "[*] missing bash_aliases"
fi

# load servers aliases
if [ -f ~/.servers_aliases ]
    then 
        source ~/.servers_aliases
    else
        echo "[*] missing servers_aliases"
fi

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $"

xset r rate 180
