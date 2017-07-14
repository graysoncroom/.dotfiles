#!/bin/bash

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb ~/.Xresources
#synergyc 10.1.10.130 # Just for work machine
exec i3
