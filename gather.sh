#!/bin/sh
# convert all inputs to pdfs, and merge to one
# might not work when filenames contain speciale chars

for var in "$@"; do
    convert "$var" "$var.pdf" && rm "$var"
done

files="$( echo "$@" | sed 's: \|$:\.pdf :g' )"
# intentional splitting of $files into separate variables
pdftk $files cat output merged.pdf && rm $files
