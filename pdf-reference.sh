#!/bin/bash

FILE=$(qdbus6 org.kde.okular /okular org.kde.okular.getCurrentFile)
if [ -n "$FILE" ]; then
    zathura "$FILE" &
else
    notify-send "Okular" "Nie znaleziono aktywnego dokumentu"
fi

