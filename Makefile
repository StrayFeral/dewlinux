SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -euo pipefail -c

# The folowing is to install PROJECT DEW
# by StrayF 2026


.PHONY: base main dev cyr gmail games help

DEBUG ?= 0

base: main dev cyr
	@echo ""
	@echo "Email/Gmail setup not installed. You need to install this manually."
	@echo ""
	@echo "=========================================================="
	@echo "ALL DONE."

main:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/00inst-main.sh

dev:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/99inst-dev.sh
	./scripts/98inst-devmore.sh

cyr:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/01inst-kblayouts.sh

gmail:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/03inst-gmail.sh

games:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/50inst-games.sh
	./scripts/51inst-chess.sh

help:
	@echo "TARGETS:"
	@echo "  make base		- Installation of: main dev cyr"
	@echo "  make main		- Main packages installation"
	@echo "  make dev		- Perl, Python3, Nasm, C/C++, Golang, Rust, Lua"
	@echo "  make cyr		- Installation of Cyrillic keyboard layouts"
	@echo ""
	@echo "FOR ADDITIONAL INSTALL:"
	@echo "  make gmail		- Installation and setup of email client for"
	@echo "			  GMail/Hotmail/Outlook/Live.com"
	@echo "			  (SINGLE account OAUTH2 setup !!)"
	@echo "  make games		- Games installation"
	@echo ""
	@echo "  DEBUG=1		- Sets the DEBUG flag"
