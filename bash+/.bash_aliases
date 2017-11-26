alias vi='vim'
alias archey='archey3'
alias bat='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state|to\ full|percentage"'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias swap_control_and_capslock='sudo loadkeys ~/.dotfiles/console-keys+/.keys/swap_control_and_capslock.kmap'
alias xup='xrdb ~/.Xresources'
alias pacman-orphan-remove='sudo pacman -Rns $(pacman -Qdtq)'
alias ghc='stack ghc'
alias etarun='etlas run 2> /dev/null'
alias open='xdg-open'
alias info='info --vi-keys'

# default PS1
export PS1='[\W]\$ '
alias set-normal-ps1="export PS1=$'[\[\e[01;36m\]\W\[\e[0m\]]-> '"
