SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -euo pipefail -c

# The folowing is to install PROJECT DEW
# by StrayF 2026


.PHONY: all main games dev cyr email help

DEBUG ?= 0

all: main games dev cyr
	@echo ""
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

cyr:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/01inst-kblayouts.sh

email:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/02inst-email.sh

gmail:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/03inst-gmail.sh

help:
	@echo "Targets:"
	@echo "  make all		- Full system installation"
	@echo "  make main		- Main packages installation"
	@echo "  make games		- Games installation"
	@echo "  make dev		- Development tools installation"
	@echo "  make cyr		- Installation of Cyrillic keyboard layouts"
	@echo "  make email		- Installation of email client and tools"
