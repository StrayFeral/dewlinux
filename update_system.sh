#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "UPDATING THE SYSTEM..."
echo ""

echo "Acquiring updates..."
sudo apt update
sudo apt upgrade

echo "Downloading additional updates..."
git -C wiki-tui/ pull
git -C mdterm/ pull
git -C lazytail/ pull

echo "Installing additional updates..."
cargo install --path wiki-tui/
cargo install --path mdterm/
cargo install rgx-cli
cargo install xleak
cargo install chess-tui

bash lazytail/install.sh
lazytail init

echo ""
echo "SYSTEM UPDATED."
