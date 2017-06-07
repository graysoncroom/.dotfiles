alias vi='vim'
alias archey='archey3'
alias bat='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|to\ full|percentage"'
alias ..='cd ..'

# default PS1
export PS1='[\W]\$ '

# looks like a javascript anonymous function
# just a funny ps1 I fiddle with from time
# to time
alias set-cool-ps1="export PS1=$'\[\e[01;36m\](\W)-> {\[\e[0m\]\n \E[J\] \E[1B\] \E[1G\]\[\e[01;36m\]}\E[1A\]\[\e[0m\]  '"
alias set-normal-ps1="export PS1=$'[\[\e[01;36m\]\W\[\e[0m\]]-> '"
