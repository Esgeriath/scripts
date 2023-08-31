#!/bin/sh
if [ $# != 2 ] || ! [ -d "$1" ] || ! [ -d "$2" ]; then
    echo "Usage: $0 DIR_A_PATH DIR_B_PATH
    Check whether contents of dir A are precisely subset
    of contents of dir B; that is wheter each file in A have
    corresponding file in B with the same name and contents.

    Prints filenames of A that don't match.

    Assumes '^' character is not used in A or B path."
    exit 1
fi
A_dir="$1"
B_dir="$2"

find "$A_dir" -type f | sed "s^$A_dir/^^" | while read -r fn; do
    if [ -f "$B_dir/$fn" ]; then
        if ! diff "$A_dir/$fn" "$B_dir/$fn" >/dev/null; then
            echo "$fn"
        fi
    else
        echo "$fn"
    fi
done

