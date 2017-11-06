#!/usr/bin/env bash 

unset CDPATH

export PYENV_ROOT="${XDG_HOME:-$HOME/.local}/toolchain/pyenv"
test -d "$PYENV_ROOT" || mkdir -p "$PYENV_ROOT"
cd "$PYENV_ROOT"

git clone "https://github.com/valeth/pyenv.git" .
git checkout setup
git submodule update --init --recursive

# Add the following to the config.fish file.
#
#   set -x PYENV_ROOT (xdg_home 'toolchain' 'pyenv')
#   unshift_path PATH "$PYENV_ROOT/bin"
#   status is-interactive; and source (pyenv init -|psub)
#   status is-interactive; and source (pyenv-virtualenv init -|psub)
