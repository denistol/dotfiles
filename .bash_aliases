
# BASE
alias v='vim'
alias ls='ls --color=auto'
alias ll='ls -ltha --color=auto'
alias eb='vim ~/.bashrc'
alias ea='vim ~/.bash_aliases'
#alias cat='cat -n'
alias exres='vim ~/.Xresources'
alias ecron='crontab -e'
alias sb='source ~/.bashrc'


alias paci='sudo pacman -S --color=auto'
alias pacs='pacman -Ss --color=auto'
alias yai='yaourt -S'
alias yas='yaourt -Ss'

# GIT
alias gs='git status'
alias gc='git commit'
alias gall='git add --all'
alias gpush='git push'
alias gpull='git push'
alias gf='git fetch'
alias gch='git checkout'

# OTHER
alias ytv='youtube-viewer'
alias sc='$WEBBROWSER soundcloud.com &'
alias goog='$WEBBROWSER google.com &'


# DEV
alias runs='python manage.py runserver'

#FUNCS

# find in history
function his {
    history | grep $1
}
# find files
function ff {
    find $1 -type f -iname *$2*
}

#find directories
function fd {
    find $1 -type d -iname *$2*
}
