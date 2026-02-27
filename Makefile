SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -euo pipefail -c

# The folowing is to install PROJECT DEW
# by StrayF 2026


.PHONY: all main games dev cyr help

DEBUG ?= 0

all: main games dev cyr
	@echo ""
	@echo "Email/Gmail setup not installed. You need to install this manually."
	@echo ""
	@echo "=========================================================="
	@echo "ALL DONE."

main:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/00inst-main.sh

games:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/50inst-games.sh

dev:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/99inst-dev.sh

devmore:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/98inst-devmore.sh

cyr:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/01inst-kblayouts.sh

#email:
#	[[ "$(DEBUG)" == 1 ]] && set -x
#	./scripts/02inst-email.sh

gmail:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/03inst-gmail.sh

help:
	@echo "Targets:"
	@echo "  make all		- Installation of everything, except gmail and devmore"
	@echo "  make main		- Main packages installation"
	@echo "  make games		- Games installation"
	@echo "  make dev		- Python3 and Perl tools installation"
	@echo "  make cyr		- Installation of Cyrillic keyboard layouts"
	@echo ""
	@echo "THE FOLOWING TARGETS ARE **NOT** INCLUDED IN 'make all':"
	#@echo "  make email		- Installation of email client and tools"
	@echo "  make gmail		- Installation and setup of email client for"
	@echo "			  GMail/Hotmail/Outlook/Live.com"
	@echo "			  (SINGLE account OAUTH2 setup !!)"
	@echo "  make devmore		- NASM, Lua, Golang, Rust and tools installation"
	@echo ""
	@echo "  DEBUG=1		- Sets the DEBUG flag"
