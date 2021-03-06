# Source global definitions

[ -f /etc/bashrc ]     && source /etc/bashrc
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.localrc ]      && source ~/.localrc

herbstcompletionfile=/usr/share/bash-completion/completions/herbstclient
[ -f "$herstcompletionfile" ] && . "$herstcompletionfile" 

#[ -f ~/.Xresources ] && xrdb ~/.Xresources

set -o noclobber # |> instead of > for redirecting file output
set -o vi # The terminal will be in vi mode

# If set, Bash checks the window size after each command and
# updates LINES and COLUMNS if necessary.
# default: on
shopt -s checkwinsize

# Allow inline comments in interactive shell
# default: on
shopt -s interactive_comments

# Paths are an implicit cd to path
# default: off
#shopt -s autocd

#eval "$(thefuck --alias)"

export PATH="$HOME/.scripts:$PATH"
#export MANPATH="/usr/local/man:/usr/local/share/man:/usr/share/man:/usr/lib/jvm/default/man"

export EDITOR="vim"
export VISUAL="vim"
export BROWSER="google-chrome-stable"
export TERMINAL="st"

# Color exports
#export COLOR_NC='\e[0m' # No Color
#export COLOR_WHITE='\e[1;37m'
#export COLOR_BLACK='\e[0;30m'
#export COLOR_BLUE='\e[0;34m'
#export COLOR_LIGHT_BLUE='\e[1;34m'
#export COLOR_GREEN='\e[0;32m'
#export COLOR_LIGHT_GREEN='\e[1;32m'
#export COLOR_CYAN='\e[0;36m'
#export COLOR_LIGHT_CYAN='\e[1;36m'
#export COLOR_RED='\e[0;31m'
#export COLOR_LIGHT_RED='\e[1;31m'
#export COLOR_PURPLE='\e[0;35m'
#export COLOR_LIGHT_PURPLE='\e[1;35m'
#export COLOR_BROWN='\e[0;33m'
#export COLOR_YELLOW='\e[1;33m'
#export COLOR_GRAY='\e[0;30m'
#export COLOR_LIGHT_GRAY='\e[0;37m'

function extract { # {{{
    extract_fail_msg="don't know how to extract '$1'..." 
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xvjf "$1"            ;;
            *.tar.gz)  tar xvzf "$1"            ;;
            *.bz2)     bunzip2 "$1"             ;;
            *.rar)     unrar x "$1"             ;;
            *.gz)      gunzip "$1"              ;;
            *.tar)     tar xvf "$1"             ;;
            *.tbz2)    tar xvjf "$1"            ;;
            *.tgz)     tar xvzf "$1"            ;;
            *.zip)     unzip "$1"               ;;
            *.Z)       uncompress "$1"          ;;
            *.7z)      7z x "$1"                ;;
            *)         echo "$extract_fail_msg" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
} # }}}

function sendemail {
    curl --url "smtps://smtp.gmail.com:465" --ssl-reqd --mail-from $gmailuser --mail-rcpt $1 --upload-file $2 --user "$gmailuser:$gmailpass" --insecure;
}

function get-hex {
    echo "$1" | hexdump -C
}
 
function fzf {
    fzf --preview='head -$LINES {}' --bind 'ctrl-j:down,ctrl-k:up'
}

# default
#export PS1='[\W]\$ '

# ascii arrow
#export PS1=$'[\[\e[01;36m\]\W\[\e[0m\]] -> '

# unicode arrow
#export PS1=$'[\[\e[01;36m\]\W\[\e[0m\]] \xe2\x86\x92 '

# unicode lambda
# export PS1=$'[\[\e[01;36m\]\W\[\e[0m\]] \[\e[1;91m\]\xce\xbb\[\e[0m\] '

# unicode lambda and unicde arrow
#export PS1=$'\[\e[1;91m\]λ \[\e[0m\]\[\e[3;36m\]\W\[\e[0m\]\[\e[1;32m\] ➜ \[\e[0m\]'

export PS1='\[\e[1;32m\] ➜ \[\e[0m\]\[\e[3;36m\]\W\[\e[0m\] '

#neofetch

#export NVIM_LISTEN_ADDRESS=/tmp/neovim/neovim nvim

# The following command needs to be on the last line
#eval "$(starship init bash)"
