#!/bin/sh

#systemctl start bluetooth.service
bluetoothctl power on
# słuchawki MOEVI
bluetoothctl connect 33:33:33:38:35:A6
# słuchawki JBL Tune
# bluetoothctl connect E8:D0:3C:85:64:F6

##include <unistd.h>
#
#int main() {
#    setuid(geteuid());
#    char ** args;
#    execv("headphones.sh", args);
#    return 1;
#}
