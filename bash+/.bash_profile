#xset r rate MS_DELAY RATE
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec startx
else
    [ -f ~/.bashrc ] && . ~/.bashrc
fi


