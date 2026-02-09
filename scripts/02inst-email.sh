#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT


echo "INSTALLING EMAIL TOOLS..."

echo "**** WORK IN PROGRESS ******"
sudo apt -y install neomutt msmtp msmtp-mta offlineimap ca-certificates gnupg pass # Mail client

echo ""
echo "EMAIL TOOLS INSTALLED."
