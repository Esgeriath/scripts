#!/bin/bash

sudo -v
sudo /home/esgeriath/.local/repo/reTablet/main.py > /dev/null &

# if pgrep Hyprland; then
#     DEVICE="$(hyprctl monitors | grep Monitor | cut -d' ' -f2 | tail -n1)"
#     swaymsg input 0:0:Virtual_Mouse/Tablet map_to_output "$DEVICE"
# fi
if pgrep sway; then
    DEVICE="$(swaymsg -t get_outputs | jq -r '.[] | select(.name | test("DP")) | .name ' | tail -n 1)"
    swaymsg input 0:0:Virtual_Mouse/Tablet map_to_output "$DEVICE"
fi

ssh -l root remarkable "pgrep goMarkableStream || ./goMarkableStream &"
