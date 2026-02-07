#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR

echo "INSTALLING GAMES..."

sudo apt -y install bsdgames            # Collection of old BSD games
sudo apt -y install pacman4console      # PacMan clone
sudo apt -y install nudoku              # Sudoku
sudo apt -y install frotz
sudo apt -y install cowsay              # Not a game, but it's a classic
sudo apt -y install bastet              # Tetris clone
sudo apt -y install vitetris            # Tetris clone
