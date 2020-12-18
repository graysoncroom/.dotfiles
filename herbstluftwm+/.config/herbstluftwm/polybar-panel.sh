#!/usr/bin/env bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
    for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$monitor polybar --reload mainbar-herbst &
    done
else
    polybar --reload mainbar-herbst &
fi
