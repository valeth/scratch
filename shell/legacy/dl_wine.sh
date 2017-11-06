#!/usr/bin/env bash

ARCH="x86"

BASE_URL="http://playonlinux.com/wine"

GECKO_BASE_URL="${BASE_URL}/gecko/$arch"
MONO_BASE_URL="${BASE_URL}/mono"

dl_wine()
{
    local wine_ver="$1"
    local arch="${2:-$ARCH}"
    local binaries_base_url="${BASE_URL}/binaries/linux-${arch}"

    local wine_file="PlayOnLinux-wine-${wine_ver}-linux-${arch}.pol"

    curl -O -C - "${binaries_base_url}/${wine_file}"

    curl -O -C - "${binaries_base_url}/${wine_file}.sha1"
    sha1sum -c "${wine_file}.sha1"
    rm "${wine_file}.sha1"

    mv "${wine_file}" "${wine_file//pol/tar.bz}"
}

dl_wine "$@"
