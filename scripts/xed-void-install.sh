#!/bin/bash

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

echo "Installing Xed dependencies..."
echo ""
# Install repo dependencies.
sudo xbps-install -Sy xapps

echo "Downloading Xed text editor..."
# Download DEB packages from Linux Mint's repository.
mkdir xed 
cd xed
wget http://packages.linuxmint.com/pool/backport/x/xed/xed_2.8.4+ulyssa_amd64.deb
wget http://packages.linuxmint.com/pool/backport/x/xed/xed-common_2.8.4+ulyssa_all.deb
wget http://packages.linuxmint.com/pool/backport/x/xapp/xapps-common_2.0.7+ulyssa_all.deb
wget http://packages.linuxmint.com/pool/backport/x/xed/xed-doc_2.8.4+ulyssa_all.deb
# Convert them with XDEB.

echo "Converting Xed packages with XDEB..."
echo ""
/home/$USER/.local/share/bin/xdeb -Sde xed_2.8.4+ulyssa_amd64.deb
/home/$USER/.local/share/bin/xdeb -Sde xed-common_2.8.4+ulyssa_all.deb
/home/$USER/.local/share/bin/xdeb -Sde xapps-common_2.0.7+ulyssa_all.deb
/home/$USER/.local/share/bin/xdeb -Sde xed-doc_2.8.4+ulyssa_all.deb

# Install converted packages.
echo "Installing Xed text editor..."
sudo xbps-install -y --repository binpkgs xed-2.8.4_1 xed-common-2.8.4_1 xed-doc-2.8.4_1 xapps-common-2.0.7_1
cd ../..

echo ""
echo "Compiling Glib schemas..."
echo ""
#Compiling schemas is necessary in order to make Xed work. Without this, you'll get an error when trying to open Xed.
sudo glib-compile-schemas /usr/share/glib-2.0/schemas

echo "Cleaning install files to save space..."
# Clean files.
rm -rf install
