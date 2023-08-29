#!/bin/bash

if [ $# != 1 ]; then
    echo "provide filename"
    exit 1
fi

echo "processing document $1"
echo "(exit zathura to end page selection)"
PAGES="$(zathura $1 2>/dev/null | sort -n | uniq | xargs echo)"
echo "selected pages: $PAGES"

echo "creating new file..."
pdftk $1 cat $PAGES output "sel-$1"
