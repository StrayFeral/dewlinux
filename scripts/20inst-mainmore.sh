#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING MAIN MORE..."
echo ""

echo "Downloading ADDITIONAL MAIN packages, this will take approx 6 minutes, please wait..."
echo ""

export PATH="$PATH:~/.local/bin:~/bin:~/.cargo/bin"

# Wikipedia client
rm -rf /tmp/wiki-tui
git clone --depth 1 https://github.com/Builditluc/wiki-tui /tmp/wiki-tui
echo ""
echo "Compiling wiki-tui, please wait ..."
cargo install -q --path /tmp/wiki-tui/ --force

echo ""
echo "Compiling xleak, please wait ..."
cargo install -q xleak --force                # Excel XLS viewer

# Markdown (MD) viewer
rm -rf /tmp/mdterm
git clone --depth 1 https://github.com/bahdotsh/mdterm.git /tmp/mdterm
echo ""
echo "Compiling mdterm, please wait ..."
cargo install -q --path /tmp/mdterm/ --force

echo ""
echo "MAIN MORE COMPONENTS INSTALLED."
