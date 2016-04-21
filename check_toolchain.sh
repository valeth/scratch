#!/usr/bin/env bash

declare -A VERSIONS

# NOTE: python 2 does not seem to use stdout for --version
declare -A APPLICATIONS=(
    [ghc]='--version |cut -d" "  -f8'
    [gcc]='--version |head -n1 |cut -d" " -f3'
    [g++]='--version |head -n1 |cut -d" " -f3'
    [make]='--version |head -n1 |cut -d" " -f3'
    [clang]='--version |head -n1 |cut -d" " -f3'
    [bash]='--version |head -n1 |cut -d" " -f4'
    [zsh]='--version |cut -d" " -f2'
    [python2]='-c "import sys; print(sys.version)" |head -n1 |cut -d" " -f1'
    [python3]='--version |cut -d" " -f2'
    [lua]='-v |cut -d" " -f2'
    [luac]='-v |cut -d" " -f2'
    [autoconf]='--version |head -n1 |cut -d" " -f4'
    [automake]='--version |head -n1 |cut -d" " -f4'
    [awk]='--version |head -n1 |cut -d" " -f3-5'
    [sed]='--version |head -n1 |cut -d" " -f4'
    [patch]='--version |head -n1 |cut -d" " -f3'
    [git]='--version |cut -d" " -f3'
    [cmake]='--version |head -n1 |cut -d" " -f3'
    [ctags]='--version |head -n1 |cut -d" " -f3'
    [tmux]='-V |cut -d" " -f2'
    [vim]='--version |head -n1 |cut -d" " -f5'
    [konsole]='--version |tail -n1 |cut -d" " -f2'
)


function getVersion
{
    if test 2 != $#; then
        return 1
    fi

    local app="$1"
    local check_args="$2"

    # check if program is in PATH
    if type -p "$app" 1>&2>/dev/null; then
        VERSIONS[$app]=$(eval "$app" "$check_args" 2>/dev/null)
    fi
}

function main
{
    for app in "${!APPLICATIONS[@]}"; do
        args=${APPLICATIONS[$app]}
        getVersion "$app" "$args"
    done

    if test 0 == $#; then
        for app in "${!VERSIONS[@]}"; do
            version=${VERSIONS[$app]}
            printf "%12s ..... %s\n" "$app" "$version"
        done
    fi
}

main "$@"

