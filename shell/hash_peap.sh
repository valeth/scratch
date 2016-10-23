#!/usr/bin/env bash

if type -p iconv openssl stty >/dev/null; then
    stty -echo && read -r -p "enter password: " passwd
    stty echo
    printf "\n"
    echo "hash:$(echo -n "$passwd" | iconv -t utf16le | openssl md4 | cut -d\  -f2)"
else
    echo "iconv, openssl and stty not found in PATH"
fi

