SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -euo pipefail -c

# The folowing is to install PROJECT DEW
# by StrayF 2026


.PHONY: base main dev cyr gmail games help mainmore

DEBUG ?= 0

MAKEFILEPATH := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

base: main dev cyr mainmore
	@echo ""
	@echo "Email/Gmail setup and games were installed. You need to install this manually."
	@echo ""
	@echo "=========================================================="
	@echo "ALL DONE."

main:
	[[ "${DEBUG}" == 1 ]] && set -x
	${MAKEFILEPATH}/scripts/00inst-main.sh

dev:
	[[ "${DEBUG}" == 1 ]] && set -x
	${MAKEFILEPATH}/scripts/00inst-main.sh/scripts/99inst-dev.sh
	${MAKEFILEPATH}/scripts/00inst-main.sh/scripts/98inst-devmore.sh

cyr:
	[[ "${DEBUG}" == 1 ]] && set -x
	${MAKEFILEPATH}/scripts/00inst-main.sh/scripts/01inst-kblayouts.sh
	
mainmore:
	[[ "${DEBUG}" == 1 ]] && set -x
	 ${MAKEFILEPATH}/scripts/20inst-mainmore.sh

gmail:
	[[ "${DEBUG}" == 1 ]] && set -x
	 ${MAKEFILEPATH}/scripts/03inst-gmail.sh

games:
	[[ "${DEBUG}" == 1 ]] && set -x
	 ${MAKEFILEPATH}/scripts/50inst-games.sh
	 ${MAKEFILEPATH}/scripts/51inst-chess.sh

help:
	@echo "TARGETS:"
	@echo "  make base		- Installation of: main dev cyr mainmore"
	@echo "  make main		- Main packages installation"
	@echo "  make dev		- Perl, Python3, Nasm, C/C++, Golang, Rust, Lua"
	@echo "  make cyr		- Installation of Cyrillic keyboard layouts"
	@echo "  make mainmore		- More main tools (requires: dev)"
	@echo ""
	@echo "FOR ADDITIONAL INSTALL:"
	@echo "  make gmail		- Installation and setup of email client for"
	@echo "			  GMail/Hotmail/Outlook/Live.com"
	@echo "			  (SINGLE account OAUTH2 setup !!)"
	@echo "  make games		- Games installation"
	@echo ""
	@echo "  DEBUG=1		- Sets the DEBUG flag"
