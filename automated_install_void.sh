#!/bin/bash
echo "Welcome to IceWM Tuner!"
echo "This script will install IceWM and configure a lot of things."
echo "Created by Kevin Figueroa"
echo "https://github.com/KF-Art"
echo "This script is licensed under GPLv3."
echo ""
echo "Enjoy!"
echo ""
echo "Installing IceWM and initial tools..."

sudo xbps-install -S icewm ulauncher network-manager-applet pa-applet brillo nemo qt5ct kvantum betterlockscreen sxhkd clementine xfce4-panel xfce4-whiskermenu-plugin xfce4-power-manager xfce4-clipman-plugin mate-polkit octoxbps notification-daemon playerctl numlockx compton xscreensaver setxkbmap xautolock blueman NetworkManager pulseaudio firefox pavucontrol git wget gedit eudev timeshift cronie xinit bluez dbus zzz-user-hooks

echo "Enabling services..."

#If are already enabled, delete them to avoid conflicts.
sudo rm /var/service/bluetoothd
sudo rm /var/service/NetworkManager
sudo rm /var/service/udevd
sudo rm /var/service/dbus
sudo rm /var/service/crond

#Enable services.
sudo ln -s /etc/sv/bluetoothd /var/service
sudo ln -s /etc/sv/NetworkManager /var/service
sudo ln -s /etc/sv/udevd /var/service
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/crond /var/service

mkdir install

echo "Copying IceWM configuration files..."
echo ""
cp -r dotfiles/icewm ~/.icewm
echo "Making startup script executable..."
echo ""
chmod +x ~/.icewm/startup
echo "Copying keybindings configuration file (sxhkdrc)..."
echo ""
cp -r dotfiles/sxhkd/ ~/.config
echo "Installing XDEB script"
echo ""

# XDEB installation.
sudo xbps-install -S binutils tar curl xz
cd install
git clone https://github.com/toluschr/xdeb
cd xdeb
chmod 0744 xdeb
sudo cp xdeb /usr/local/bin
cd ../..

echo "Installing Xed dependencies..."
echo ""
# Install repo dependencies.
sudo xbps-install -Sfy xapps

echo "Downloading Xed text editor..."
# Download DEB packages from Linux Mint's repository.
cd install
mkdir xed 
cd xed
wget http://packages.linuxmint.com/pool/backport/x/xed/xed_2.8.4+ulyssa_amd64.deb
wget http://packages.linuxmint.com/pool/backport/x/xed/xed-common_2.8.4+ulyssa_all.deb
wget http://packages.linuxmint.com/pool/backport/x/xapp/xapps-common_2.0.7+ulyssa_all.deb
wget http://packages.linuxmint.com/pool/backport/x/xed/xed-doc_2.8.4+ulyssa_all.deb
# Convert them with XDEB.

echo "Converting Xed packages with XDEB..."
echo ""
xdeb -Sde xed_2.8.4+ulyssa_amd64.deb
xdeb -Sde xed-common_2.8.4+ulyssa_all.deb
xdeb -Sde xapps-common_2.0.7+ulyssa_all.deb
xdeb -Sde xed-doc_2.8.4+ulyssa_all.deb
# Install converted packages.

echo "Installing Xed text editor..."
sudo xbps-install -yf --repository binpkgs xed-2.8.4_1 xed-common-2.8.4_1 xed-doc-2.8.4_1 xapps-common-2.0.7_1
cd ../..

echo "Installing Oh My ZSH..."
echo ""
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
cp dotfiles/shellrc/.zshrc ~/

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
unzip JetBrainsMono-2.225.zip
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
cp Solid/KvFlat-Emerald-Solid ~/.config/Kvantum
cd ../..

echo "Installing StarLabs-Green GTK theme..."
echo ""

cd install
tar -xvf ../resources/StarLabs-Green.tar.gz
sudo cp -r StarLabs-Green /usr/share/themes
sudo cp -r StarLabs-Green-Dark /usr/share/themes
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
cp resources/pexels-eberhard-grossgasteiger-640781.jpg  ~/.config/betterlockscreen
betterlockscreen -u -blur ~/.config/betterlockscreen/pexels-eberhard-grossgasteiger-640781

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

echo "Deleting install files to save space..."
echo ""
rm -rf install
echo "Completed."
echo ""
echo "Congratulations! You have installed a tuned IceWM!"
echo "Lastly, add this line at the end of /etc/sudoers/ via visudo, changing myusername for your username:"
echo ""
echo "myusername ALL= NOPASSWD: /usr/bin/brillo"
echo ""
echo "Sorry, I'm researching about how to automate this."






