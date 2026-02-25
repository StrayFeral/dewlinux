#!/usr/bin/env bash

echo "Re-requesting OAUTH2 authorization: $(date)"
echo ""

#if [[ $# -eq 0 ]]; then
#    echo "Usage: $0 <emailprovider>"
#    exit 1
#fi

python3 scripts/oauth2_config.py $1

