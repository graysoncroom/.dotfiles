## Safety nets
alias cp='cp -i'
alias mv='mv -i'
# The argument against the following line is:
# "The whole point of rm is to remove so having to type yes
# before removing something is just building bad muscle memory"
# I'm buying into it for now.
#alias rm='rm -i'

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
alias rr='cd ~/.config/ranger'
alias xmonaderr='cat ~/.xmonad/xmonad.errors | less'
alias xmonadconf='vim ~/.xmonad/xmonad.hs'
