#!/bin/sh
echo "Welcome to IceWM Tuner!"
echo "This script will install IceWM and configure a lot of things."
echo "Created by Kevin Figueroa"
echo "https://github.com/KF-Art"
echo "This script is licensed under GPLv3."
echo ""
echo "Enjoy!"
echo ""
echo "Installing IceWM and initial tools..."

sudo xbps-install -Sfy icewm ulauncher network-manager-applet tilix pa-applet brillo nemo qt5ct \
	zsh kvantum bsdtar betterlockscreen sxhkd clementine xfce4-panel xfce4-whiskermenu-plugin \
	xfce4-power-manager xfce4-clipman-plugin mate-polkit octoxbps notification-daemon playerctl \
	numlockx compton xscreensaver setxkbmap xautolock blueman NetworkManager pulseaudio firefox \
	pavucontrol git wget gedit eudev timeshift cronie xinit bluez dbus zzz-user-hooks

echo "Enabling services..."

#Enable services.
sudo ln -sf /etc/sv/{bluetoothd,NetworkManager,udevd,dbus,crond} /var/service

echo "Copying IceWM configuration files..."
echo ""
if [ ! -d "$HOME/.icewm" ]; then
	mkdir "$HOME/.icewm"
	cp -r dotfiles/icewm/* "$HOME/.icewm"
else
	cp -r dotfiles/icewm/* "$HOME/.icewm"
fi

echo "octoxbps-notifier &" >> "$HOME/.icewm/startup"
echo "Making startup script executable..."
echo ""
chmod u+x "$HOME/.icewm/startup"
echo "Copying keybindings configuration file (sxhkdrc)..."
echo ""
cp -r dotfiles/sxhkd/ "$HOME/.config"

echo "Installing XDEB script"
echo ""

# Install dependencies for XDEB
sudo xbps-install -Sfy binutils bsdtar curl 
sudo ln -s /usr/bin/bsdtar /usr/local/bin/tar
sudo ln -s /usr/bin/bsdtar /usr/local/bin/xz

# Clone XDEB repository in our home
mkdir "$HOME/github"
git -C "$HOME/github" clone https://github.com/toluschr/xdeb
chmod u+x "$HOME/github/xdeb/xdeb"

# Create symbolic link of the XDEB binary to our personal path
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

# Compile Glib schemas. Without this, Xed will not work.
echo ""
echo "Compiling Glib schemas..."
echo ""
sudo glib-compile-schemas /usr/share/glib-2.0/schemas

echo "Downloading San Francisco Pro font..."
echo ""
git -C "$HOME/github" clone https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts
cd "$HOME/github/San-Francisco-Pro-Fonts"
if [ ! -d "/usr/share/fonts/OTF" ]; then
	sudo mkdir /usr/share/fonts/OTF
	sudo mv *.otf /usr/share/fonts/OTF
else
	sudo mv *.otf /usr/share/fonts/OTF
fi

echo "Downloading JetBrains Mono font..."
echo ""
cd $INSTALL
mkdir JetBrains-Mono && cd JetBrains-Mono
wget https://github.com/JetBrains/JetBrainsMono/releases/download/v2.225/JetBrainsMono-2.225.zip
bsdtar -xf JetBrainsMono-2.225.zip
sudo cp -r fonts /usr/share

echo "Updating font cache and list..."
echo ""
fc-cache -fv; fc-list

# Pending qt5ct variable
echo "Installing KvFlat-Emerald theme..."
echo ""
git -C "$HOME/github" clone https://github.com/KF-Art/KvFlat-Emerald/
cd "$HOME/github/KvFlat-Emerald"
if [ ! -d "$HOME/.config/Kvantum" ]; then
	mkdir "$HOME/.config/Kvantum"
	cp -r KvFlat-Emerald-Solid "$HOME/.config/Kvantum/"
else
	cp -r KvFlat-Emerald-Solid "$HOME/.config/Kvantum/"
fi

echo ""
echo "Installing StarLabs-Green GTK theme..."
echo ""
cd "$HOME/github/icewm-personal-tunning"
sudo bsdtar -xvf resources/StarLabs-Green.tar.gz -C /usr/share/themes

echo "Installing Reversal icon theme..."
git -C "$HOME/github" clone https://github.com/yeyushengfan258/Reversal-icon-theme
cd "$HOME/github/Reversal-icon-theme"
sudo ./install.sh -a

echo "Caching betterlockscreen background..."
echo ""
if [ ! -d "$HOME/.config/betterlockscreen/" ]; then
	mkdir "$HOME/.config/betterlockscreen/"
fi
cd "$HOME/github/icewm-personal-tunning"
cp resources/pexels-eberhard-grossgasteiger-640781.jpg  "$HOME/.config/betterlockscreen/"
betterlockscreen -u -blur "$HOME/.config/betterlockscreen/pexels-eberhard-grossgasteiger-640781.jpg"

echo "Copying GTK configurations..."
echo ""
cp -r dotfiles/gtk-3.0 "$HOME/.config/"

echo "Copying Qt5ct configurations.."
echo ""
if [ ! -d "$HOME/.config/qt5ct" ]; then
	mkdir "$HOME/.config/qt5ct"
	cp dotfiles/qt5ct/qt5ct.conf "$HOME/.config/qt5ct/"
else
	cp dotfiles/qt5ct/qt5ct.conf "$HOME/.config/qt5ct/"
fi

echo "Copying uLauncher configurations..."
echo ""
cp -r dotfiles/ulauncher "$HOME/.config"

echo "Copying XFCE's panel configurations..."
echo ""
cp -r dotfiles/xfce4 "$HOME/.config/"

echo ""
echo "Configuring Tilix..."
dconf load /com/gexperts/Tilix/ < resources/tilixrc
echo ""

echo "Copying .xinitrc..."
cp dotfiles/xinitrc/.xinitrc "$HOME/"
echo ""

echo ""
echo "Copying Kvantum configuration file..."
cp dotfiles/Kvantum/kvantum.kvconfig "$HOME/.config/Kvantum/"
echo ""

# Add lines to ~/.bashrc
echo ""
echo "Adding custom Bash prompt..."
echo ""
if [ -f "$HOME/.bashrc" ]; then
	sed -i 's/PS1/#PS1/g' "$HOME/.bashrc"
	cat resources/custom-prompt-bash | tee -a "$HOME/.bashrc"
else
	touch "$HOME/.bashrc"
	cat resources/custom-prompt-bash | tee "$HOME/.bashrc"
fi

echo "Adding variables to ~/.bashrc..."
cat resources/shell_variables | tee -a "$HOME/.bashrc"

echo ""
echo "Adding sudo exceptions to use brillo..."
sudo groupadd brillo
sudo usermod -aG brillo "$USER"
echo '%brillo ALL=(ALL) NOPASSWD: /usr/bin/brillo /usr/bin/zzz' | sudo EDITOR='tee -a' visudo
echo ""
echo "If you will use another user in the future, you need to add them to brillo group."
echo ""

echo "Deleting install files to save space..."
echo ""
# Optionally you can remove the repository from github in case you are no longer going to use them
#rm -rf $HOME/github
rm -rf $INSTALL
echo "Completed."
echo ""
echo "Congratulations! You have installed a tuned IceWM!"
echo "Now you can use startx to begin enjoy your new environment."







