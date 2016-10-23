#!/usr/bin/env bash

function getGlobalIP
{
    server="${1:-http://checkip.dyndns.org}"
    searchpat="[0-9]{1,3}(\.[0-9]{1,3}){3}"
    curl -s "$server" | grep -oE "$searchpat"
}

getGlobalIP "$@"
