# Source global definitions

[ -f /etc/bashrc ] && . /etc/bashrc
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.localrc ] && . ~/.localrc
#[ -f ~/.Xresources ] && xrdb ~/.Xresources

set -o vi

export EDITOR="vim"
export VISUAL="vim"

# Color exports
export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[0;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'

sendemail() {
	curl --url "smtps://smtp.gmail.com:465" --ssl-reqd --mail-from $gmailuser --mail-rcpt $1 --upload-file $2 --user "$gmailuser:$gmailpass" --insecure; 
}

# {sending: true, quotaRemaining: 40, textId: 12345}
# {sending: false, quotaRemaining: 0, error: 'Out of quota'}
# https://textbelt.com
sendtext() {
	curl http://textbelt.com/text \
	     --data-urlencode number=$1 \
	     --data-urlencode message=$2;
}

# make connecting to new networks less painful
# $wifiPassDir should be set in ~/.localrc
# will only work after you connect to the network once in kde the first time
# the name of the file must be the name generated after that first use when you
# run the command 'nmcli c' with a suffix of '-PASSWORD'
# when you run the function use the name of the network without the suffix specified by
# the file it gets the password from.
# follow the format of the other -PASSWORD files when you create new one
wifi-connect() {
  if [ $1 == '' ]; then
    echo "Enter name of network as specified by the command of 'nmcli connect'"
    echo "Usage: wifi-connect [name of network]"
  else
    sudo nmcli c up $1 passwd-file $wifiPassDir/$1-PASSWORD
    passwdFile=''
    networkName=''
  fi
}

set-normal-ps1
#archey
