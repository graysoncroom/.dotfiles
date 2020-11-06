#!/bin/bash

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb ~/.Xresources

[ -f /bin/feh ] && feh --bg-scale Downloads/anime-wallpaper.jpg
[ -f /bin/xcompmgr ] && xcompmgr -c & &> /dev/null
[ -f /bin/xmobar ] && xmobar & &> /dev/null

exec xmonad
