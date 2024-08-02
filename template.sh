#!/bin/sh
if [ -d "$HOME/Templates/" ]; then
    dir="$HOME/Templates"
elif [ -d "$HOME/Szablony/" ]; then
    dir="$HOME/Szablony"
else
    echo "No Templates directory"
    exit 1
fi

if file="$(find "$dir" -type f | \
    sed "s@$dir/@@" | fzf)"; then
    read -p "Enter new name (empty for defalut): " name
    if [ "$name" = "" ]; then
        cp "$dir/$file" .
    else
        cp "$dir/$file" "./$name"
    fi
fi
