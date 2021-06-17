#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi
if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi
# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

##### MY PART ################################################################

# Compositor
picom -f &

# Wallpaper
nitrogen --restore &

# Damn bell
xset b off

# Notifications
/usr/bin/dunst &

# Monitor, key repeat, language, caps->esc
$HOME/.config/scripts/monitor laptop &

# xinput, TouchPad
$HOME/.config/scripts/xinput_config &

# Java issues
export AWT_TOOLKIT=MToolkit

# Exec xmonad
exec xmonad

# slstatus
#exec $HOME/.config/slstatus/slstatus/slstatus &

# Execute DWM
#exec dwm

# i3-gaps
#exec i3
