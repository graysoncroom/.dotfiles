export EDITOR="vim"
export VISUAL="vim"

set -o vim #Use vim movements in shell

# Load bash aliases from file: bash_aliases
if [ -f ~/.bash_aliases ] then
	. ~/.bash_aliases
fi
