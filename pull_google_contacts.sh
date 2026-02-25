#!/usr/bin/env bash
cp ~/.abook/addressbook ~/.abook/addressbook.bak

echo "About to download Google contacts: $(date)"
echo ""

python3 scripts/pull_contacts.py

