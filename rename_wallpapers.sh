#!/bin/bash

cd "$1" || exit 1
for file in ./*;  do
    sxiv "$file" &
    read new_name
    new_name="$new_name.$(cut -f 3 -d . <<< "$file")"
    if [ -f "$new_name" ]; then
        echo "ERROR: file \'$newname\' exists"
        continue
    else
        mv "$file" "$new_name"
    fi
done
