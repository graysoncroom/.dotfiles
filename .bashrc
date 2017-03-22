
export EDITOR="vim"
export VISUAL="vim"

#Use vim movements in shell
set -o vim

# Load bash aliases from file: bash_aliases
if [ -f ~/.bash_aliases ] then
	. ~/.bash_aliases
fi
