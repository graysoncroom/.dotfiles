#!/bin/bash

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap
[ -f ~/.Xresources ] && xrdb ~/.Xresources
synergyc 10.1.10.130
exec i3
