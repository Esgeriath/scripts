#!/bin/sh

# A script to display 16 base colors of terminal.

for a in $(seq 40 47); do 
    echo -ne "\e[$a""m     \e[0;37;40m "
done
echo
for a in $(seq 100 107); do 
    echo -ne "\e[$a""m     \e[0;37;40m "
done
echo ""

