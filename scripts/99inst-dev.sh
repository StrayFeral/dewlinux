#!/bin/bash
set -euo pipefail

# Debugging
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR

echo "INSTALLING SOFTWARE DEVELOPMENT TOOLS..."

sudo apt -y install vim-ale
# Since vim is already installed
# you can use vimdiff

sudo apt -y install hexcurse  # Hex editor

sudo apt -y install python3
sudo apt -y install python3-pip

# Perl is already installed by default
# These are useful tools for Perl
sudo apt -y install perlnavigator
sudo apt -y install libperl-critic-perl
sudo apt -y install perltidy
