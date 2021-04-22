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

while true
do
        VOL=$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')
        LOCALTIME=$(date +%Z\=%Y-%m-%dT%H:%M)
        OTHERTIME=$(TZ=Europe/Stockholm date +%Z\=%H:%M)
        IP=$(for i in `ip r`; do echo $i; done | grep -A 1 src | tail -n1) # can get confused if you
        TEMP="$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))C"

        if acpi -a | grep off-line > /dev/null
        then
                BAT="Bat. $(acpi -b | awk '{ print $4 " " $5 }' | tr -d ',')"
                xsetroot -name "$IP $BAT $VOL $TEMP $LOCALTIME $OTHERTIME"
        else
                xsetroot -name "$IP $VOL $TEMP $LOCALTIME $OTHERTIME"
        fi
        sleep 20s
done &


# Loop
while true; do
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


  # Caps -> Esc
  $HOME/.config/scripts/xmod_caps.sh &

  # xinput, TouchPad
  $HOME/.config/scripts/xinput_config.sh &

  # Java issues
  export AWT_TOOLKIT=MToolkit

  dwm >/dev/null 2>&1
done

# Execute DWM
#exec dwm




exec i3
