#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

DEWPATH=""
if [ -n "${MAKEFILEPATH:-}" ]; then
    DEWPATH="${MAKEFILEPATH}/"
fi

echo ""
echo "INSTALLING SOFTWARE DEVELOPMENT TOOLS..."
echo ""

echo "Downloading DEVELOPMENT packages, this will take approx 2:30 minutes, please wait..."
echo ""

sudo apt-get install -y -qq --no-upgrade vim-ale hexcurse hexedit xxd tidy \
    python3 python-is-python3 python3-pip pipx python3-isort python3-pylsp-black python3-flake8 python3-mypy python3-bandit \
    perlnavigator libperl-critic-perl perltidy

pipx ensurepath

# Copying the vim-ale config
if [ ! -f ~/.vimrc ] || ! grep -q "= DEWLINUX ALE" ~/.vimrc; then
    cat "${DEWPATH}configs/vim_ale_config" >> ~/.vimrc
fi

echo ""
echo "SOFTWARE DEVELOPMENT TOOLS INSTALLED."
