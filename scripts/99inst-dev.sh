#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING SOFTWARE DEVELOPMENT TOOLS..."
echo ""

echo "Downloading packages, this may take some time, please wait..."
echo ""

sudo apt install -y -qq --no-upgrade vim-ale hexcurse hexedit xxd tidy \
    python3 python-is-python3 python3-pip pipx python3-isort python3-pylsp-black python3-flake8 python3-mypy python3-bandit \
    perlnavigator libperl-critic-perl perltidy

pipx ensurepath

# Copying the vim-ale config
cat configs/vim_ale_config >> ~/.vimrc

echo ""
echo "SOFTWARE DEVELOPMENT TOOLS INSTALLED."
