#!/usr/bin/env bash 

unset CDPATH

export RBENV_ROOT="${XDG_HOME:-$HOME/.local}/toolchain/rbenv"
test -d "$RBENV_ROOT" || mkdir -p "$RBENV_ROOT"
cd "$RBENV_ROOT"

git clone "https://github.com/valeth/rbenv.git" .
git checkout setup
git submodule update --init --recursive

# Add the following to the config.fish file.
#
#   set -x RBENV_ROOT (xdg_home 'toolchain' 'rbenv')
#   unshift_path PATH "$RBENV_ROOT/bin"
#   status is-interactive; and source (rbenv init -|psub)

# NOTE:
#    In order to compile Ruby version 2.3.x with OpenSSL > 1.0 (Arch Linux)
#    set the following environment variables and install the library and compiler.
#
#    packages:
#      gcc-5
#      openssl-1.0
#   
#    variables:
#      CC=/usr/bin/gcc-5
#      PKG_CONFIG_PATH=/usr/lib/openssl-1.0/pkgconfig