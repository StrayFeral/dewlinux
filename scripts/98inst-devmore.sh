#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING MORE SOFTWARE DEVELOPMENT TOOLS..."
echo ""

echo "Downloading packages, this may take some time, please wait..."
echo ""

sudo apt-get install -y -qq --no-upgrade gdb nasm golang-go rustup lua5.4 luarocks luajit

# Golang tools
# Language type: compiled, like c/c++
# Source file extension: .go
# Run/compile: go build
# Install modules: go get

# Rust tools
# Language type: compiled, like c/c++
# Source file extension: .rs
# Run/compile: rustc
# Install modules: cargo
rustup install 1.88

# Lua tools
# Language type: interpreted, like perl/python
# Source file extension: .lua
# Run/compile: lua5.4
# Install modules: luarocks

echo "Compiling rgx-cli ..."
cargo install -q rgx-cli                    # Regex tester

echo ""
echo "MORE SOFTWARE DEVELOPMENT TOOLS INSTALLED."
