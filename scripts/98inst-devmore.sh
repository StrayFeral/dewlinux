#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING MORE SOFTWARE DEVELOPMENT TOOLS..."
echo ""

# GNU Debugger
sudo apt -y install gdb

# Netwide Assembler
echo "Installing Netwide Assembler"
sudo apt -y install nasm

# Golang tools
# Language type: compiled, like c/c++
# Source file extension: .go
# Run/compile: go build
# Install modules: go get
echo "Installing Golang"
sudo apt -y install golang-go

# Rust tools
# Language type: compiled, like c/c++
# Source file extension: .rs
# Run/compile: rustc
# Install modules: cargo
echo "Installing Rust"
sudo apt -y install rustc
sudo apt -y install cargo

# Lua tools
# Language type: interpreted, like perl/python
# Source file extension: .lua
# Run/compile: lua5.4
# Install modules: luarocks
echo "Installing Lua"
sudo apt -y install lua5.4
sudo apt -y install luarocks
sudo apt -y install luajit

echo ""
echo "MORE SOFTWARE DEVELOPMENT TOOLS INSTALLED."
