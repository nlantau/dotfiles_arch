#!/usr/bin/env bash
# nlantau 2021-04-17

# Cannot get i3 to run all commands in one script, for some reason
# Keeping this for later...

# Get Touchpad ID
IDTOUCH=$(xinput list | grep TouchPad | cut -f 2 | grep -Eo '[0-9]{1,2}')
SCROLLPROP=$(xinput list-props $IDTOUCH | grep -E 'Natural Scrolling Enabled \('| grep -Eo '[0-9]{2,3}')
TAPPROP=$(xinput list-props $IDTOUCH | grep -E 'Tapping Enabled \('| grep -Eo '[0-9]{2,3}')

# Get G603 ID
G603ID=$(xinput list | grep G603 | grep -v keyboard | cut -f2 | grep -Eo '[0-9]{1,2}')
GSCROLLPROP=$(xinput list-props $G603ID | grep -E 'Natural Scrolling Enabled \(' | cut -f2 | grep -Eo '[0-9]{1,3}')

# Remaps
xmodmap -e "clear lock"
xmodmap -e "keysym Caps_Lock = Escape"

# Enable natural scrolling
xinput set-prop $IDTOUCH $SCROLLPROP 1
xinput set-prop $G603ID $GSCROLLPROP 1

# Enable tap
xinput set-prop $IDTOUCH $TAPPROP 1

# Set TouchPad Speed
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Accel Speed' 0.6

# Faster key repeat and delay
xset r rate 300 50

# Remove bell sound
xset b off

# Keyboard Layout
setxkbmap se &




