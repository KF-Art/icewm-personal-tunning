#!/bin/sh

# This script need to be run with a fully compatible POSIX shell, like sh, mksh or oksh. ZSH and Bash are not working.

mkdir "$HOME/github"
echo "Installing XDEB script"
echo ""

# XDEB installation.
sudo xbps-install -Sfy binutils bsdtar curl
sudo ln -s /usr/bin/bsdtar /usr/local/bin/tar
sudo ln -s /usr/bin/bsdtar /usr/local/bin/xz

git -C "$HOME/github" clone https://github.com/toluschr/xdeb
chmod u+x "$HOME/github/xdeb/xdeb"
if [ ! -d "$HOME/.local/share/bin" ]; then
	mkdir "$HOME/.local/share/bin"
	ln -s "$HOME/github/xdeb/xdeb" "$HOME/.local/share/bin/"
else
	ln -s "$HOME/github/xdeb/xdeb" "$HOME/.local/share/bin/"
fi
export PATH="$HOME/.local/share/bin:$PATH"

# Temporary directory for building packages using XDEB
mkdir /tmp/install
INSTALL=/tmp/install

echo "Installing Xed dependencies..."
echo ""
# Install repo dependencies.
sudo xbps-install -Sy xapps

echo "Downloading Xed text editor..."
# Download DEB packages from Linux Mint's repository.
cd $INSTALL
mkdir xed && cd xed
dash -c 'echo "xed_2.8.4+ulyssa_amd64.deb\nxed-common_2.8.4+ulyssa_all.deb\nxed-doc_2.8.4+ulyssa_all.deb"' >> xed_packages
dash -c 'for i in $(cat xed_packages); do curl -O http://packages.linuxmint.com/pool/backport/x/xed/$i; done'

# Convert them with XDEB.
echo "Converting Xed packages with XDEB..."
echo ""
dash -c 'for i in $(cat xed_packages); do xdeb -Sde $i; done'

# Install converted packages.
echo "Installing Xed text editor..."
sudo xbps-install -y -R binpkgs xed xed-common xed-doc

echo ""
echo "Compiling Glib schemas..."
echo ""
#Compiling schemas is necessary in order to make Xed work. Without this, you'll get an error when trying to open Xed.
sudo glib-compile-schemas /usr/share/glib-2.0/schemas

echo "Cleaning install files to save space..."
# Clean files.
unlink "$HOME/.local/share/bin/xdeb"
# Delete xdeb repository if it will not be used again
# rm -rf "$HOME/github/xdeb"
rm -rf $INSTALL
