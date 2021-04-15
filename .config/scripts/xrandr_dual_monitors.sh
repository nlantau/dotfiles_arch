#!/usr/bin/env bash
# nlantau, 2021-04-14

#xrandr --output DP-3 --mode 1920x1080 --right-of eDP-1
#xrandr --output DP-1 --mode 1920x1080 --right-of DP-3

RIGHT=$(mons | tail -n 2 | grep -Eo '([0-9]:){1}' | head -n 1 | grep -Eo '[0-9]')
LEFT=$(mons | tail -n 2 | grep -Eo '([0-9]:){1}' | tail -n 1 | grep -Eo '[0-9]')

mons -S $LEFT,$RIGHT:R

