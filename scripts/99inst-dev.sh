#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING SOFTWARE DEVELOPMENT TOOLS..."
echo ""

sudo apt -y install vim-ale                 # Great vim plugin
# Since vim is already installed
# you can use vimdiff

sudo apt -y install hexcurse                # Hex editor

# Python 3
sudo apt -y install python3
sudo apt -y install python-is-python3       # Not truly needed, but convenient
sudo apt -y install python3-pip

# Python tools
sudo apt -y install python3-isort
sudo apt -y install python3-pylsp-black
sudo apt -y install python3-flake8
sudo apt -y install python3-mypy
sudo apt -y install python3-bandit

# Perl is already installed by default
# These are useful tools for Perl
sudo apt -y install perlnavigator
sudo apt -y install libperl-critic-perl
sudo apt -y install perltidy

# Copying the vim-ale config
cat configs/vim_ale_config >> ~/.vimrc

echo ""
echo "SOFTWARE DEVELOPMENT TOOLS INSTALLED."
