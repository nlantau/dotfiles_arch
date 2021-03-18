#!/usr/bin/env bash

# nlantau, 2021-03-18


# Get Touchpad ID
IDTOUCH=$(xinput list | grep Touchpad | cut -f 2 | grep -Eo '[0-9]{1,2}')
SCROLLPROP=$(xinput list-props 13 | grep -E 'Natural Scrolling Enabled \('| grep -Eo '[0-9]{2,3}')
TAPPROP=$(xinput list-props 13 | grep -E 'Tapping Enabled \('| grep -Eo '[0-9]{2,3}')


# Enable natural scrolling
xinput set-prop $IDTOUCH $SCROLLPROP 1

# Enable tap
xinput set-prop $IDTOUCH $TAPPROP 1

# TODO: G603
