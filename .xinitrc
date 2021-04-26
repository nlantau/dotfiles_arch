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


# Monitor, key repeat, language, caps->esc
$HOME/.config/scripts/monitor laptop &

# Faster key repeat and delay
#xset r rate 300 50

# Remove Bell sound
#xset b off

# Keyboard Language
#setxkbmap se -option 'caps:ctrl_modifier' &

# Caps Lock is Esc when pressed alone, but CTRL in combination
#xcape -e 'Caps_Lock=Escape' &

# Compositor
picom -f &

# Wallpaper
nitrogen --restore &

# Notifications
/usr/bin/dunst &

# xinput, TouchPad
$HOME/.config/scripts/xinput_config &

# Java issues
export AWT_TOOLKIT=MToolkit

# slstatus
exec $HOME/.config/slstatus/slstatus/slstatus &

# Execute DWM
exec dwm

#exec i3
