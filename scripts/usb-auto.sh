#!/bin/bash

DEV="/dev/$1"

sleep 2

OUTPUT=$(udisksctl mount -b "$DEV" 2>/dev/null)

MOUNT_POINT=$(echo "$OUTPUT" | sed -n 's/.* at \(.*\)\.$/\1/p')

[ -z "$MOUNT_POINT" ] && exit 0

who | while read user tty rest; do
    echo "New device is now connected as '$MOUNT_POINT'" > "/dev/$tty"
done
