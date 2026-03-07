#!/bin/bash

if ! dpkg-query -W -f='${Status}' "stockfish" 2>/dev/null | grep -q "ok installed"; then
    echo "Chess games are not installed. You should run: make games"
    exit 1
fi

cage foot chess-tui
