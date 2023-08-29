#!/bin/sh

new="$(kcolorchooser --print 2> /dev/null)"
colors=""
while [ ! "$new" = "#ffffff" ]; do
    colors="$colors$new\n"
    new="$(kcolorchooser --print 2> /dev/null)"
#    if [ ! "$(printf "y\nn" | dmenu -p "continue?")" = "y" ]; then
#        break;
#    fi
done
printf "$colors"
