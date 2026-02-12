#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING ADDITIONAL KEYBOARD LAYOUTS..."
echo ""

# This will install the Bulgarian and Russian phonetic layouts
# and will make them switchable with LEFTALT+LEFTSHIFT keys
sudo sed -i 's/^\(XKBLAYOUT=\".*\)\"/\1,bg,ru\"/' /etc/default/keyboard
sudo sed -i 's/^\(XKBVARIANT=\".*\)\"/\1,phonetic,phonetic\"/' /etc/default/keyboard
sudo sed -i 's/^\(XKBOPTIONS=\".*\"\)/XKBOPTIONS=\"grp:lalt_lshift_toggle\"/' /etc/default/keyboard
sudo setupcon

# Automatically set the a font with proper Cyrillic support
sudo debconf-set-selections <<EOF
console-setup console-setup/store_defaults_in_debconf_db boolean true
console-setup console-setup/codesetcode string Uni3
console-setup console-setup/charmap string UTF-8
console-setup console-setup/fontface string TerminusBold
console-setup console-setup/fontsize string 12x24
console-setup console-setup/fontsize-text string 12x24
console-setup console-setup/fontsize-fb string 12x24
console-setup console-setup/codeset string Combined
EOF

sudo dpkg-reconfigure -f noninteractive console-setup



# IMPORTANT:
# In order for the Cyrillic characters to be visualized properly on the
# terminal, you must select the proper terminal font:
# dpkg-reconfigure console-setup
# and select these in sequence: encoding, character set, font, font size

# So these charsets would work great:
# #Cyrillic - Slavic languages (also Bosnian and Serbian latin)
# OR
# .Combined - Latin; Slavic and non-Slavic Cyrillic

# Please not the "#" and the "." signs in front of the selected charsets

# For a font I personally select TerminusBold 12x24 (framebuffer-only)

echo ""
echo "KEYBOARD LAYOUTS INSTALLED."
