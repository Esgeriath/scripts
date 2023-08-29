#!/bin/zsh
while read fn; do
    if [ -f "/mnt/usb2/prywatne/Z telefonu/$fn" ]; then
        if diff "/mnt/usb2/prywatne/Z telefonu/$fn" "000_$fn" >/dev/null; then
            echo "/mnt/usb2/prywatne/Z telefonu/$fn"
            rm -rf "/mnt/usb2/prywatne/Z telefonu/$fn"
        fi
    fi
done < /tmp/filenames

