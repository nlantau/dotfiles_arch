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

# Faster key repeat and delay
xset r rate 300 50

# Remove Bell sound
xset b off

# Keyboard Language
setxkbmap se &

# Compositor
picom -f &

# Wallpaper
nitrogen --restore &

# Notifications
/usr/bin/dunst &

# xinput, TouchPad
$HOME/.config/scripts/xinput_config.sh &

# Java issues
export AWT_TOOLKIT=MToolkit

#nm-applet > /dev/null 2>&1 &



# Execute DWM
exec $HOME/.config/slstatus/slstatus/slstatus &

exec dwm

#exec i3
