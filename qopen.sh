#!/bin/sh

if CHOICE=$(cut -f1 -d\` ~/.local/share/qopen.txt | fuzzel -d -l 10)
then
    eval "$(grep "$CHOICE\`" ~/.local/share/qopen.txt | cut -f2 -d\`)"
fi
