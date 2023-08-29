#!/bin/sh

if file="$(find "$HOME/Templates/" -type f | \
    sed "s@$HOME/Templates/@@" | fzf)"; then
    read -p "Enter new name (empty for defalut): " name
    if [ "$name" = "" ]; then
        cp "$HOME/Templates/$file" .
    else
        cp "$HOME/Templates/$file" "./$name"
    fi
fi
