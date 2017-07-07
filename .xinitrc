#!/bin/bash

# Please comment all changes Grayson.
# You aren't a fucking kernel dev so stop documenting your code like one!

if [[ -f ~/.Xmodmap ]]; then 
	xmodmap ~/.Xmodmap
fi

# xrandr --auto --output DP2 --primary --mode 1920x1080 --left-of LVDS1 --auto

exec i3
