#!/bin/bash

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
# [ -f ~/.Xresources ] && xrdb ~/.Xresources
[ -f ~/.Xresources ] && xrdb ~/.Xresources
# [ -f ~/.Xresources ] && xrdb -merge <~/.Xresources

# [ -f /bin/feh ] && feh --bg-scale ~/Images/wallpapers/anime/anime-wallpaper.jpg
# [ -f /bin/xcompmgr ] && xcompmgr -c &> /dev/null &
# [ -f /bin/xmobar ] && xmobar &> /dev/null &
[ -f /usr/bin/xinput ] && xinput disable 'SynPS/2 Synaptics TouchPad'

#[ -f /usr/bin/xsetroot ] && xsetroot -cursor_name left_ptr

#exec xmonad
#exec dwm
#exec firefox
#exec i3
exec herbstluftwm --locked
