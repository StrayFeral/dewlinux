SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -euo pipefail -c

# The folowing is to install PROJECT DEW
# by StrayF 2006


.PHONY: all main games dev help

DEBUG ?= 0

all: main games dev

main:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/00inst-main.sh

games:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/50inst-games.sh

dev:
	[[ "$(DEBUG)" == 1 ]] && set -x
	./scripts/99inst-dev.sh

help:
	@echo "Targets:"
	@echo "  make all		- Full system installation"
	@echo "  make main		- Main packages installation"
	@echo "  make games		- Games installation"
	@echo "  make dev		- Development tools installation"
