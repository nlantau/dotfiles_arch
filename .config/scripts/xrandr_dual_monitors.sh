#!/usr/bin/env bash
# nlantau, 2021-04-14

#xrandr --output DP3 --mode 1920x1080 --right-of eDP1
#xrandr --output DP1 --mode 1920x1080 --right-of DP3

xrandr --output eDP1 --off
xrandr --output DP3 --auto --right-of eDP1
xrandr --output DP1 --mode 1920x1080 --right-of DP3

#RIGHT=$(mons | tail -n 2 | grep -Eo '([0-9]:){1}' | head -n 1 | grep -Eo '[0-9]')
#LEFT=$(mons | tail -n 2 | grep -Eo '([0-9]:){1}' | tail -n 1 | grep -Eo '[0-9]')

#mons -S $LEFT,$RIGHT:R

