#!/bin/sh

# This script need to be run with a fully compatible POSIX shell, like sh, mksh or oksh. ZSH and Bash are not working.

mkdir install
echo "Installing XDEB script"
echo ""

# XDEB installation.
sudo xbps-install -Sy binutils tar curl xz
cd install
git clone https://github.com/toluschr/xdeb
cd xdeb
chmod u+x xdeb
mkdir ~/.local/share/bin
sudo cp xdeb ~/.local/share/bin/
cd ..

XDEB=~/.local/share/bin/xdeb

echo "Installing Xed dependencies..."
echo ""
# Install repo dependencies.
sudo xbps-install -Sy xapps

echo "Downloading Xed text editor..."
# Download DEB packages from Linux Mint's repository.
mkdir xed 
cd xed
echo "xed_2.8.4+ulyssa_amd64.deb\nxed-common_2.8.4+ulyssa_all.deb\nxed-doc_2.8.4+ulyssa_all.deb" >> xed_packages
for i in $(cat xed_packages); do curl -O http://packages.linuxmint.com/pool/backport/x/xed/$i; done
# Convert them with XDEB.

echo "Converting Xed packages with XDEB..."
echo ""
for i in $(cat xed_packages); do $XDEB -Sde $i; done

# Install converted packages.
echo "Installing Xed text editor..."
sudo xbps-install -y --repository binpkgs xed-2.8.4_1 xed-common-2.8.4_1 xed-doc-2.8.4_1
cd ../..

echo ""
echo "Compiling Glib schemas..."
echo ""
#Compiling schemas is necessary in order to make Xed work. Without this, you'll get an error when trying to open Xed.
sudo glib-compile-schemas /usr/share/glib-2.0/schemas

echo "Cleaning install files to save space..."
# Clean files.
rm -rf install
