#!/bin/bash

# 1. Get a list of all partitions on USB-transport devices
# We use -P (pairs) to make parsing 100% reliable regardless of screen width
MAP=$(lsblk -pbP -o NAME,SIZE,FSTYPE,MODEL,TRAN | grep 'TRAN="usb"' | grep 'TYPE="part"' || lsblk -pbP -o NAME,SIZE,FSTYPE,MODEL,TRAN | grep 'TRAN="usb"')

# Note: Some systems show partitions as 'part', others just show the 'disk'. 
# We'll filter for actual mountable partitions.
USB_PARTS=$(lsblk -pno NAME,SIZE,LABEL,FSTYPE,MODEL,TRAN | grep "usb" -A 5 | grep -E "part|sda[0-9]|sdb[0-9]|sdc[0-9]")

if [ -z "$USB_PARTS" ]; then
    echo "No USB partitions found!"
    exit 1
fi

echo "Found the following USB devices:"
echo "--------------------------------"

# 2. Use a 'while' loop to create a clean menu
IFS=$'\n'
count=1
declare -A dev_map

while read -r line; do
    # Clean up the line for display (remove the tree characters)
    display_line=$(echo "$line" | sed 's/[└├]─//g' | xargs)
    echo "$count) $display_line"
    
    # Store the device path in an array
    dev_map[$count]=$(echo "$display_line" | awk '{print $1}')
    
    ((count++))
done <<< "$USB_PARTS"

echo "--------------------------------"
read -p "Enter the number to mount (or 'q' to quit): " choice

if [[ "$choice" == "q" ]]; then
    exit 0
fi

SELECTED_DEV=${dev_map[$choice]}

if [ -z "$SELECTED_DEV" ]; then
    echo "Invalid selection."
    exit 1
fi

echo "Mounting $SELECTED_DEV..."
udisksctl mount -b "$SELECTED_DEV"

