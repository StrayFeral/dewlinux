#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING CHESS GAMES..."
echo ""
echo "This requires installation of the devmore tools"

sudo apt -y install fairymax
sudo apt -y install phalanx
sudo apt -y install stockfish
sudo apt -y install gnuchess

# sudo apt -y install pychess

# export CARGO_TARGET_DIR=/tmp/cargo-target
# cargo install chess-tui --locked
# cargo install chess-tui

echo ""
echo "CHESS GAMES INSTALLED."
