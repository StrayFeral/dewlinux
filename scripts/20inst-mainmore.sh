#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING MAIN MORE..."
echo ""

export PATH="$PATH:$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin"

# Wikipedia client
git clone https://github.com/Builditluc/wiki-tui
cargo install wiki-tui

# Neoscim - another spreadsheet
# wget https://git.oliveratkinson.net/Oliver/neoscim/actions/runs/23/artifacts/neoscim -O /tmp/neoscim.zip
# unzip /tmp/neoscim.zip -d ~/.cargo/bin/
# chmod +x ~/.cargo/bin/neoscim

echo ""
echo "MAIN MORE COMPONENTS INSTALLED."
