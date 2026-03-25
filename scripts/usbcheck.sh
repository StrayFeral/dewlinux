#!/bin/bash

udevadm monitor --subsystem-match=block --property | \
while read -r line; do
    case "$line" in
        ACTION=add)
            ACTION=add
            ;;
        DEVNAME=/dev/sd*)
            DEVNAME="${line#DEVNAME=}"
            ;;
        DEVTYPE=partition)
            DEVTYPE=partition
            ;;
        ID_FS_USAGE=filesystem)
            if [ "$ACTION" = "add" ] && [ "$DEVTYPE" = "partition" ]; then
                sleep 1
                OUTPUT=$(udisksctl mount -b "$DEVNAME" 2>/dev/null)
                MOUNT_POINT=$(echo "$OUTPUT" | sed -n 's/.* at \(.*\)\.$/\1/p')

                if [ -n "$MOUNT_POINT" ]; then
                    echo "New device is now connected as '$MOUNT_POINT'"
                fi
            fi
            ACTION=""
            DEVTYPE=""
            DEVNAME=""
            ;;
    esac
done
