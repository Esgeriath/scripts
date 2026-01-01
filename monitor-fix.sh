#!/bin/sh

# sway
# output=$(swaymsg -t get_outputs | jq -r '.[] | select(.active) | .name' | grep -v eDP)
# swaymsg output "$output" pos 0 0 res 1920x1080 bg '$bgt' fill

# hyprland
~/.config/hypr/monitors.sh
