#!/usr/bin/env bash

# nlantau, 2021-03-18

# Get Touchpad ID
IDTOUCH=$(xinput list | grep Touchpad | cut -f 2 | grep -Eo '[0-9]{1,2}')
SCROLLPROP=$(xinput list-props $IDTOUCH | grep -E 'Natural Scrolling Enabled \('| grep -Eo '[0-9]{2,3}')
TAPPROP=$(xinput list-props $IDTOUCH | grep -E 'Tapping Enabled \('| grep -Eo '[0-9]{2,3}')

# Get G603 ID
G603ID=$(xinput list | grep G603 | grep -v keyboard | cut -f2 | grep -Eo '[0-9]{1,2}')
GSCROLLPROP=$(xinput list-props $G603ID | grep -E 'Natural Scrolling Enabled \(' | cut -f2 | grep -Eo '[0-9]{1,3}')

# Enable natural scrolling
xinput set-prop $IDTOUCH $SCROLLPROP 1
xinput set-prop $G603ID $GSCROLLPROP 1

# Enable tap
xinput set-prop $IDTOUCH $TAPPROP 1

