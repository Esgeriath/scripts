#!/bin/bash

# if CHOICE="$(find "$HOME/cur-sem/" -type f -not -path '*/.*' | \
#     sed "s@$HOME/cur-sem/@@" | \
#     dmenu -i -c -l 10)"
if DIR="$(find -L "$HOME/cur-sem/" -maxdepth 1 -type d | \
    xargs basename -a | grep -v "cur-sem" | dmenu -i -c -l 10)"; then
    if CHOICE="$(find "$HOME/cur-sem/$DIR" -maxdepth 1 | \
        sed "s@$HOME/cur-sem/$DIR@@; /./!d" | \
        dmenu -i -c -l 10)"; then
        if [ -f "$HOME/cur-sem/$DIR/$CHOICE" ]; then
            case "$CHOICE" in
                *.txt)
                    lst -e "nvim" "$HOME/cur-sem/$DIR/$CHOICE"
                ;;

                *.sh)
                    exec "$HOME/cur-sem/$DIR/$CHOICE"
                ;;

                *.pdf | *.dvi)
                    zathura "$HOME/cur-sem/$DIR/$CHOICE"
                ;;

                *.png | *.jpg)
                    sxiv "$HOME/cur-sem/$DIR/$CHOICE"
                ;;
                
                *)
                    xdg-open "$HOME/cur-sem/$DIR/$CHOICE"
                ;;
            esac
        elif [ -d "$HOME/cur-sem/$DIR/$CHOICE" ]; then
            lst -e vifm "$HOME/cur-sem/$DIR/$CHOICE"
        else
            exit 2
        fi
    fi
else
    echo $DIR
    exit 1
fi
