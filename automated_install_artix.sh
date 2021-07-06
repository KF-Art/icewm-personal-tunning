#!/bin/bash
#This script is in early WIP. Be careful.

echo "Welcome to IceWM Tuner!"
echo "This script will install IceWM and configure a lot of things."
echo "Created by Kevin Figueroa"
echo "https://github.com/KF-Art"
echo "This script is licensed under GPLv3."
echo ""
echo "Enjoy!"

mkdir install
echo "Installing Yay AUR helper..."
cd install
sudo pacman -S --needed --noconfirm base-devel git
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd ../..

echo ""
echo "Enabling Arch Linux support..."
echo ""
sudo pacman -S --needed --noconfirm artix-archlinux-support 

# Add Arch Linux repos to pacman.conf. Hope that in the future this is not necessary.
cat resources/pacman-arch-support.conf | sudo tee -a /etc/pacman.conf
sudo pacman -Sy

echo ""
echo "Installing IceWM and initial tools..."

sudo pacman -S --needed --noconfirm icewm network-manager-applet tilix nemo qt5ct zsh kvantum-qt5 unzip zip tar sxhkd clementine xfce4-panel xfce4-whiskermenu-plugin xfce4-power-manager xfce4-clipman-plugin mate-polkit octopi octopi-notifier-frameworks notification-daemon playerctl numlockx xscreensaver xorg-setxkbmap xautolock blueman networkmanager pulseaudio firefox pavucontrol git wget eudev cronie cronie-runit xorg-xinit bluez dbus xed
yay -Sa --noconfirm --needed ulauncher pa-applet-git timeshift-bin betterlockscreen compton-old-git

echo "Enabling services..."

#Enable services.
sudo ln -s /etc/runit/sv/{bluetoothd,NetworkManager,udevd,dbus,cronie} /run/runit/service/

echo "Copying IceWM configuration files..."
echo ""
mkdir ~/.icewm
cp -r dotfiles/icewm/* ~/.icewm
echo "/usr/bin/octopi-notifier &" >> ~/.icewm/startup
echo "
echo "Making startup script executable..."
echo ""
chmod +x ~/.icewm/startup
echo "Copying keybindings configuration file..."
echo ""
cp -r dotfiles/sxhkd/ ~/.config

echo
echo "Installing Oh My ZSH..."
echo ""
cd install
mkdir .oh-my-zsh
cd .oh-my-zsh
tar -xvf ../../resources/oh-my-zsh.tar.gz
cd ..
cp -r .oh-my-zsh ~/
cp ../dotfiles/shellrc/.zshrc ~/

echo "Changing the default shell to ZSH..."
chsh -s /usr/bin/zsh
cd ..

echo ""
echo "Downloading San Francisco Pro font..."
echo ""
cd install
git clone https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts
cd San-Francisco-Pro-Fonts
sudo mkdir /usr/share/fonts/OTF
sudo mv *.otf /usr/share/fonts/OTF
cd ..

echo ""
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
betterlockscreen -u -blur ~/.config/betterlockscreen/pexels-eberhard-grossgasteiger-640781.jpg

echo "Setting wallpaper..."
betterlockscreen -w ~/.config/betterlockscreen/pexels-eberhard-grossgasteiger-640781.jpg

echo "Copying GTK configurations..."
echo ""
mkdir ~/.config/gtk-3.0
cp -r dotfiles/gtk-3.0 ~/.config/

echo "Copying Qt5ct configurations.."
echo ""
mkdir ~/.config/qt5ct
cp dotfiles/qt5ct/qt5ct.conf ~/.config/qt5ct/

echo "Copying uLauncher configurations..."
echo ""
mkdir ~/.config/ulauncher
cp -r dotfiles/ulauncher ~/.config

echo "Copying XFCE panel configurations..."
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
echo "%brillo ALL=(ALL) NOPASSWD: /usr/bin/brillo /usr/bin/zzz" | sudo EDITOR=tee -a visudo
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
