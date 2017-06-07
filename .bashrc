# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

if [ -f ~/.localrc ]; then
	. ~/.localrc
fi

export EDITOR="vim"
export VISUAL="vim"

set -o vi

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

# Bash commands to run before User may interact with shell
set-normal-ps1
#archey
