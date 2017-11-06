#!/usr/bin/env bash 

unset CDPATH

export NODENV_ROOT="${XDG_HOME:-$HOME/.local}/toolchain/nodenv"
test -d "$NODENV_ROOT" || mkdir -p "$NODENV_ROOT"
cd "$NODENV_ROOT"

git clone "https://github.com/valeth/nodenv.git" .
git checkout setup
git submodule update --init --recursive

# Add the following to the config.fish file.
#
#   set -x NODENV_ROOT (xdg_home 'toolchain' 'nodenv')
#   unshift_path PATH "$NODENV_ROOT/bin"
#   status is-interactive; and source (nodenv init -|psub)
