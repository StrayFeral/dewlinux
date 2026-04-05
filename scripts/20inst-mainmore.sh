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
cargo install -q wiki-tui

cargo install -q xleak                      # Excel XLS viewer

# Markdown (MD) viewer
git clone https://github.com/bahdotsh/mdterm.git
cargo install -q --path mdterm/

echo ""
echo "MAIN MORE COMPONENTS INSTALLED."
