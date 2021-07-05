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

sudo xbps-install -Sy icewm ulauncher network-manager-applet tilix pa-applet brillo nemo qt5ct zsh kvantum unzip zip tar betterlockscreen sxhkd clementine xfce4-panel xfce4-whiskermenu-plugin xfce4-power-manager xfce4-clipman-plugin mate-polkit octoxbps notification-daemon playerctl numlockx compton xscreensaver setxkbmap xautolock blueman NetworkManager pulseaudio firefox pavucontrol git wget gedit eudev timeshift cronie xinit bluez dbus zzz-user-hooks

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
mkdir ~/.icewm
cp -r dotfiles/icewm/* ~/.icewm
echo "Making startup script executable..."
echo ""
chmod +x ~/.icewm/startup
echo "Copying keybindings configuration file (sxhkdrc)..."
echo ""
cp -r dotfiles/sxhkd/ ~/.config

echo "Installing Oh My ZSH..."
echo ""
cd install
mkdir .oh-my-zsh
cd .oh-my-zsh
tar -xvf ../../resources/oh-my-zsh.tar.gz
cd ..
cp -r .oh-my-zsh ~/
cp ../dotfiles/shellrc/.zshrc ~/
cd ..

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
cd ../..

echo "Installing Xed dependencies..."
echo ""
# Install repo dependencies.
sudo xbps-install -Sy xapps

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
/home/$USER/.local/share/bin/xdeb -Sde xed_2.8.4+ulyssa_amd64.deb
/home/$USER/.local/share/bin/xdeb -Sde xed-common_2.8.4+ulyssa_all.deb
/home/$USER/.local/share/bin/xdeb -Sde xapps-common_2.0.7+ulyssa_all.deb
/home/$USER/.local/share/bin/xdeb -Sde xed-doc_2.8.4+ulyssa_all.deb
# Install converted packages.

echo "Installing Xed text editor..."
sudo xbps-install -y --repository binpkgs xed-2.8.4_1 xed-common-2.8.4_1 xed-doc-2.8.4_1 xapps-common-2.0.7_1
cd ../..

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
cp -r Solid/KvFlat-Emerald-Solid ~/.config/Kvantum
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
cp resources/pexels-eberhard-grossgasteiger-640781.jpg  ~/.config/betterlockscreen/
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

echo ""
echo "Adding sudo exceptions to use brillo..."
sudo groupadd brillo
sudo usermod -aG brillo $USER
echo '%brillo ALL= NOPASSWD: /usr/bin/brillo /usr/bin/zzz' | sudo EDITOR='tee -a' visudo
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







