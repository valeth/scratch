#!/usr/bin/env bash

if test "$USER" != "root"; then
    echo "Needs to be run as root"
    exit 1
fi

if test -n "$1" && test -n "$2"; then
    iso="$1"
    usb="$2"
    
    if test -e "$iso" && test -b "$usb"; then
        dd status=progress bs=4M if="$iso" of="$usb" && sync
    fi
else
    echo "Usage:  $0 ISO DEV"
    exit 0
fi

