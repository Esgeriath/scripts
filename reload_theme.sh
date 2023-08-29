#!/bin/sh

xrdb $HOME/.Xresources
#xrdb -merge $HOME/themes/curr/Xresources
xdotool keydown super
sleep 0.01
xdotool key F5
sleep 0.01
xdotool keyup super

