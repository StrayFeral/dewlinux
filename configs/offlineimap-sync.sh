#!/bin/bash
# Simple offlineimap sync wrapper

LOGFILE="$HOME/.offlineimap.log"

# Prevent multiple instances
if pgrep -x offlineimap >/dev/null; then
    echo "offlineimap is already running" >> "$LOGFILE"
    exit 1
fi

echo "Starting offlineimap at $(date)" >> "$LOGFILE"
offlineimap >> "$LOGFILE" 2>&1
echo "Finished offlineimap at $(date)" >> "$LOGFILE"

