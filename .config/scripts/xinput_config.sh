#!/usr/bin/env bash

# Get Touchpad ID
ID=$(xinput list | grep Touchpad | cut -f 2 | tr -d id=)

# Enable natural scrolling
xinput set-prop $ID 314 1

# Enable tap
xinput set-prop $ID 332 1

# TODO: G603
