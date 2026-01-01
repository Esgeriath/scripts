#!/bin/bash

if [ $# -lt 1 ]; then
    DIRECTORY="$HOME/cur-sem/"
else # Must end with /
    DIRECTORY="$1"
fi

while true; do
    CHOICE="$(find "$DIRECTORY" -maxdepth 1 | \
        sed "s@$DIRECTORY@@; /./!d" | fuzzel -d )"
    if [ $? != 0 ]; then
        exit 1
    fi
    if [ -f "$DIRECTORY/$CHOICE" ]; then
        case "$CHOICE" in
            *.txt)
                alacritty -e "nvim" "$DIRECTORY/$CHOICE"
            ;;

            *.sh | *.py)
                exec "$DIRECTORY/$CHOICE"
            ;;

            *.pdf | *.dvi | *.djvu)
                zathura "$DIRECTORY/$CHOICE"
            ;;

            *.png | *.jpg)
                swayimg "$DIRECTORY/$CHOICE"
            ;;
            
            *)
                xdg-open "$DIRECTORY/$CHOICE"
            ;;
        esac
        exit 0
    elif [ -d "$DIRECTORY/$CHOICE" ]; then
        DIRECTORY="$DIRECTORY/$CHOICE"
    else
        exit 2
    fi
done
