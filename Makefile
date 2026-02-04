.PHONY: all main games dev help

all: main games dev

main:
        ./scripts/00main.sh

games:
        ./scripts/50games.sh

dev:
        ./scripts/99dev.sh

help:
        @echo "Targets:"
        @echo "  make all      - Full system installation"
        @echo "  make main     - Main packages installation"
        @echo "  make games    - Games installation"
        @echo "  make dev      - Development tools installation"
