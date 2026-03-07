#!/usr/bin/env bash

echo "About to download Google contacts: $(date)"
echo ""

if ! dpkg-query -W -f='${Status}' "offlineimap" 2>/dev/null | grep -q "ok installed"; then
    echo "Email tools are not installed. You should run: make gmail"
    exit 1
fi

cp ~/.abook/addressbook ~/.abook/addressbook.bak
python3 scripts/pull_contacts.py

