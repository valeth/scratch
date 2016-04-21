#!/usr/bin/env bash

if type -p iconv openssl stty >/dev/null; then
  stty -echo && read -p "enter password: " passwd
  stty echo
  printf "\n"
  hash=$(echo $(echo -n "$passwd" | iconv -t utf16le | openssl md4 | cut -d= -f2))
  echo "hash:$hash"
else
  echo "iconv, openssl and stty not found in PATH"
fi

