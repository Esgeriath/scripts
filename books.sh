#!/bin/sh
if [ $# -lt 1 ]; then
    dir="$HOME/Dokumenty/studia/books"
elif [ $# -eq 1 ]; then
    if [ -d "$1" ]; then
        dir="$1"
    else
        echo "fuzzel zathura luncher"
        echo "usage: $0 [ directory ]"
        echo "default directory: books"
        exit 1
    fi
else
    echo "fuzzel zathura luncher"
    echo "usage: $0 [ directory ]"
        echo "default directory: books"
    exit 1
fi
choice="$(find "$dir" -type f -printf '%f\n' | grep -e "pdf" -e "djvu" | fuzzel -d -w 100)"
if [ -n "$choice" ] ; then
    file="$(find "$dir" -type f | grep "$choice")"
    if [ -r "$file" ]; then
        zathura "$file" &
    fi
fi
