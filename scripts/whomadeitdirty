#!/bin/bash

# GUI/X keywords
keywords='xserver|xorg|x11|gnome|kde|xfce|lxde|mate|cinnamon|xterm|xinit|lightdm|gdm|sddm'

echo "Searching for GUI/X package installations..."

# Check APT history logs
echo
echo "=== APT history.log ==="
grep -E 'Install:|Upgrade:' /var/log/apt/history.log | grep -E "$keywords" || echo "No matches in current history.log"

# Check rotated logs
for f in /var/log/apt/history.log.*.gz; do
    [ -f "$f" ] || continue
    echo
    echo "=== Rotated log: $f ==="
    zgrep -E 'Install:|Upgrade:' "$f" | grep -E "$keywords" || echo "No matches"
done

# Check dpkg logs
echo
echo "=== dpkg.log ==="
grep -E 'install|upgrade' /var/log/dpkg.log | grep -E "$keywords" || echo "No matches in dpkg.log"

# Check rotated dpkg logs
for f in /var/log/dpkg.log.*.gz; do
    [ -f "$f" ] || continue
    echo
    echo "=== Rotated dpkg log: $f ==="
    zgrep -E 'install|upgrade' "$f" | grep -E "$keywords" || echo "No matches"
done

# Check sudo logs for who ran apt/dpkg
echo
echo "=== Sudo / auth.log ==="
grep 'sudo' /var/log/auth.log | grep -E 'apt|dpkg' | grep -E "$keywords" || echo "No matches in auth.log"

# Check rotated auth logs
for f in /var/log/auth.log.*.gz; do
    [ -f "$f" ] || continue
    echo
    echo "=== Rotated auth log: $f ==="
    zgrep 'sudo' "$f" | grep -E 'apt|dpkg' | grep -E "$keywords" || echo "No matches"
done

# Optional: check user bash histories
echo
echo "=== User bash histories ==="
for home in /home/*; do
    hist="$home/.bash_history"
    [ -f "$hist" ] || continue
    matches=$(grep -E "apt.*($keywords)" "$hist")
    if [ -n "$matches" ]; then
        user=$(basename "$home")
        echo "User: $user"
        echo "$matches"
        echo
    fi
done

echo "Done. Review the timestamps and users above."

