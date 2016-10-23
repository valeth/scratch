#!/usr/bin/env bash

function createSnapshot
{
    local cur_dir
    local timestamp
    local subvol="$1"
    cur_dir="$(dirname "$0")"
    timestamp="$(date +%Y-%m-%d-%H-%M-%S)"

    unset CDPATH
    cd "$cur_dir" || exit 1
    btrfs subvolume snapshot -r "$subvol" "$subvol@$timestamp"
}

function listSnapshots
{
    local cur_dir
    cur_dir="$(dirname "$0")"

    unset CDPATH
    cd "$cur_dir" || exit 1
    btrfs subvolume list ./
}

createSnapshot "usr:org.archlinux:x86_64:latest"
listSnapshots

