#!/usr/bin/env bash
cp ~/.abook/addressbook ~/.abook/addressbook.bak

echo "About to download Google contacts: $(date)"
echo ""

if ! dpkg-query -W -f='${Status}' "offlineimap" 2>/dev/null | grep -q "ok installed"; then
    echo "Email tools are not installed. You should run: make gmail"
    exit 1
fi

python3 scripts/pull_contacts.py

