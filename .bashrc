# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Load bash aliases from file: bash_aliases
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# Load private information
if [ -f ~/.localrc ]; then
	. ~/.localrc
fi

# User specific aliases and functions
export EDITOR="vim"
export VISUAL="vim"

#Use vi movements in shell
set -o vi

# Function to send an email using $gmailuser / $gmailpassword
sendemail() {
	Sender += $gmailuser
	User += $gmailuser;
	User += ":";
	User += $gamilpassword;
	echo "Recpient";
	read Recpient; 
	echo "Absolute Path of Message: ";
	read Message;
	curl --url "smtps://smtp.gmail.com:465" --ssl-reqd 
	                                        --mail-from $Sender
	                                        --mail-rcpt $Recpient
	                                        --upload-file $Message
	                                        --user $User 
	                                        --insecure; 
	echo "Email Sent";
}

# Function to send a text. This text will not apear to come from my laptop to the reciever.
sendtext() {
	echo "Recpient: ";
	read textr;
	echo "Mesage: ";
	read message;
	curl http://textbelt.com/text -d number=$textr -d message=$message;
	echo "Text Sent";
}

export PS1='[\W]\$ '
