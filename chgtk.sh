#!/bin/sh
if [ $# -ne 1 ]; then
    echo "usage: $0 <gtk theme name>"
    exit 1
fi

gsettings set org.gnome.desktop.interface gtk-theme "$1"
gsettings set org.gnome.desktop.wm.preferences theme "$1"
