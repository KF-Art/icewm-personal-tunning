#!/bin/bash

# XDEB installation.
sudo xbps-install -S binutils tar curl xz
git clone https://github.com/toluschr/xdeb
cd xdeb
chmod 0744 xdeb
sudo cp xdeb /usr/local/bin
cd ..

# Install repo dependencies.
sudo xbps-install -Sfy xapps
# Download DEB packages from Linux Mint's repository.
mkdir xed && cd xed
wget http://packages.linuxmint.com/pool/backport/x/xed/xed_2.8.4+ulyssa_amd64.deb
wget http://packages.linuxmint.com/pool/backport/x/xed/xed-common_2.8.4+ulyssa_all.deb
wget http://packages.linuxmint.com/pool/backport/x/xapp/xapps-common_2.0.7+ulyssa_all.deb
wget http://packages.linuxmint.com/pool/backport/x/xed/xed-doc_2.8.4+ulyssa_all.deb
# Convert them with XDEB.
xdeb -Sde xed_2.8.4+ulyssa_amd64.deb
xdeb -Sde xed-common_2.8.4+ulyssa_all.deb
xdeb -Sde xapps-common_2.0.7+ulyssa_all.deb
xdeb -Sde xed-doc_2.8.4+ulyssa_all.deb
# Install converted packages.
sudo xbps-install -yf --repository binpkgs xed-2.8.4_1 xed-common-2.8.4_1 xed-doc-2.8.4_1 xapps-common-2.0.7_1
cd ..
# Clean files.
rm -rf xed
rm -rf xdeb
