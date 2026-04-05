#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND="noninteractive"

# Debugging
# trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND" >&2' ERR
trap 'echo "ERROR in ${BASH_SOURCE[0]} at line ${LINENO}: $BASH_COMMAND"; exit 130' INT

echo ""
echo "INSTALLING FROBTADS..."
echo ""

pushd .
cd /tmp

# Frobtads compilation
wget https://www.tads.org/frobtads/frobtads-1.2.3.tar.gz
tar -xzvf frobtads-1.2.3.tar.gz

echo "Downloading packages, this will take some time, please wait..."
echo ""

sudo apt install -y -qq --no-upgrade libncurses5-dev libncursesw5-dev libcurl4-openssl-dev

sed -i '1987s/tcur > 0/tcur != 0/' tads3/vmtz.cpp

#./configure CXXFLAGS="-O2 -fpermissive -w"
./configure CXXFLAGS="-O2 -fpermissive"

make
sudo make install

popd

echo ""
echo "FROBTADS INSTALLED."
