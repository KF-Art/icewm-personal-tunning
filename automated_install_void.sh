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

sudo xbps-install -Sfy icewm ulauncher network-manager-applet tilix pa-applet brillo nemo qt5ct zsh kvantum bsdtar betterlockscreen sxhkd clementine xfce4-panel xfce4-whiskermenu-plugin xfce4-power-manager xfce4-clipman-plugin mate-polkit octoxbps notification-daemon playerctl numlockx compton xscreensaver setxkbmap xautolock blueman NetworkManager pulseaudio firefox pavucontrol git wget gedit eudev timeshift cronie xinit bluez dbus zzz-user-hooks

echo "Enabling services..."

#Enable services.
sudo ln -sf /etc/sv/{bluetoothd,NetworkManager,udevd,dbus,crond} /var/service

mkdir install

echo "Copying IceWM configuration files..."
echo ""
mkdir ~/.icewm
cp -r dotfiles/icewm/* ~/.icewm
echo "octoxbps-notifier &" >> ~/.icewm/startup
echo "Making startup script executable..."
echo ""
chmod +x ~/.icewm/startup
echo "Copying keybindings configuration file (sxhkdrc)..."
echo ""
cp -r dotfiles/sxhkd/ ~/.config

echo "Installing XDEB script"
echo ""

# XDEB installation.
sudo xbps-install -Sfy binutils bsdtar curl 
sudo ln -s /usr/bin/bsdtar /usr/local/bin/tar
sudo ln -s /usr/bin/bsdtar /usr/local/bin/xz
cd install
git clone https://github.com/toluschr/xdeb
cd xdeb
chmod u+x xdeb
mkdir ~/.local/share/bin
sudo cp xdeb ~/.local/share/bin/
cd ../..

#Variable to simplify code.
XDEB=~/.local/share/bin/xdeb

echo "Installing Xed dependencies..."
echo ""
# Install repo dependencies.
sudo xbps-install -Sy xapps

echo "Downloading Xed text editor..."
# Download DEB packages from Linux Mint's repository.
cd install
mkdir xed 
cd xed

# The echo command is replaced by printf so that the line break is respected and the text does not remain on a single line
printf "xed_2.8.4+ulyssa_amd64.deb\nxed-common_2.8.4+ulyssa_all.deb\nxed-doc_2.8.4+ulyssa_all.deb" >> xed_packages
for i in $(cat xed_packages); do curl -O http://packages.linuxmint.com/pool/backport/x/xed/$i; done

# Convert them with XDEB.
echo "Converting Xed packages with XDEB..."
echo ""
for i in $(cat xed_packages); do $XDEB -Sde $i; done

# Install converted packages.
echo "Installing Xed text editor..."
sudo xbps-install -y --repository binpkgs xed-2.8.4_1 xed-common-2.8.4_1 xed-doc-2.8.4_1 
cd ../..

# Compile Glib schemas. Without this, Xed will not work.
echo ""
echo "Compiling Glib schemas..."
echo ""
sudo glib-compile-schemas /usr/share/glib-2.0/schemas

echo "Downloading San Francisco Pro font..."
echo ""
cd install
git clone https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts
cd San-Francisco-Pro-Fonts
sudo mkdir /usr/share/fonts/OTF
sudo mv *.otf /usr/share/fonts/OTF
cd ..

echo "Downloading JetBrains Mono font..."
echo ""
mkdir JetBrains-Mono
cd JetBrains-Mono
wget https://github.com/JetBrains/JetBrainsMono/releases/download/v2.225/JetBrainsMono-2.225.zip
bsdtar -xf JetBrainsMono-2.225.zip
sudo cp -r fonts /usr/share
cd ../..

echo "Updating font cache and list..."
echo ""
fc-cache -fv; fc-list

# Pending qt5ct variable

echo "Installing KvFlat-Emerald theme..."
echo ""
cd install
git clone https://github.com/KF-Art/KvFlat-Emerald/
cd KvFlat-Emerald
cp -r KvFlat-Emerald-Solid ~/.config/Kvantum/
cd ../..

echo ""
echo "Installing StarLabs-Green GTK theme..."
echo ""
cd install
bsdtar -xvf ../resources/StarLabs-Green.tar.gz
sudo cp -r StarLabs-* /usr/share/themes
cd ..

echo "Installing Reversal icon theme..."
cd install
git clone https://github.com/yeyushengfan258/Reversal-icon-theme
cd Reversal-icon-theme
sudo ./install.sh -a
cd ../..

echo "Caching betterlockscreen background..."
echo ""
mkdir ~/.config/betterlockscreen/
cp resources/pexels-eberhard-grossgasteiger-640781.jpg  ~/.config/betterlockscreen/
betterlockscreen -u -blur ~/.config/betterlockscreen/pexels-eberhard-grossgasteiger-640781.jpg

echo "Copying GTK configurations..."
echo ""
cp -r dotfiles/gtk-3.0 ~/.config/

echo "Copying Qt5ct configurations.."
echo ""
cp dotfiles/qt5ct/qt5ct.conf ~/.config/qt5ct/

echo "Copying uLauncher configurations..."
echo ""
cp -r dotfiles/ulauncher ~/.config

echo "Copying XFCE's panel configurations..."
echo ""
cp -r dotfiles/xfce4 ~/.config/

echo ""
echo "Configuring Tilix..."
dconf load /com/gexperts/Tilix/ < resources/tilixrc
echo ""

echo "Copying .xinitrc..."
cp dotfiles/xinitrc/.xinitrc ~/
echo ""

echo ""
echo "Copying Kvantum configuration file..."
mkdir ~/.config/Kvantum
cp dotfiles/Kvantum/kvantum.kvconfig ~/.config/Kvantum/
echo ""

# Add lines to ~/.bashrc
echo ""
echo "Adding custom Bash prompt..."
echo ""
cat resources/custom-prompt-bash | tee -a ~/.bashrc
echo "Adding variables to ~/.bashrc..."
cat resources/shell_variables | tee -a ~/.bashrc

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
rm -rf install
echo "Completed."
echo ""
echo "Congratulations! You have installed a tuned IceWM!"
echo "Now you can use startx to begin enjoy your new environment."







