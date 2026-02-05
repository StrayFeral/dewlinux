#!/bin/bash
set -euo pipefail

# Debugging
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR

echo "INSTALLING GAMES..."

sudo apt -y install bsdgames
sudo apt -y install pacman4console
sudo apt -y install nudoku
sudo apt -y install bastet  # Tetris clone
sudo apt -y install frotz
sudo apt -y install cowsay
sudo apt -y install vitetris
