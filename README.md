# IceWM Personal Tunning (WIP)
Personal customization of IceWM on mainly, Void Linux and Artix Runit. Note that other inits are not supported in this guide.

<H1>Index</H1>

 - <a href="">Overview</a>
 - <a href="https://github.com/KF-Art/icewm-personal-tunning/#special-thanks">Special Thanks</a>
 - <a href="https://github.com/KF-Art/icewm-personal-tunning/#to-do">To Do</a>
 - <a href="https://github.com/KF-Art/icewm-personal-tunning/#automated-install-wip">Automated Install (WIP)</a>
 - <a href="https://github.com/KF-Art/icewm-personal-tunning/#diy-method">DIY Method</a>
 	- <a href="https://github.com/KF-Art/icewm-personal-tunning/#installing-yay-and-enabling-arch-linux-support-artix-only">Installing Yay and Enabling Arch Linux support (Artix Only)</a>
 	- <a href="https://github.com/KF-Art/icewm-personal-tunning/#installing-icewm-and-base-packages">Installing IceWM and base packages</a>
 		- <a href="https://github.com/KF-Art/icewm-personal-tunning/#enabling-services">Enabling services</a>
 		- <a href="https://github.com/KF-Art/icewm-personal-tunning/#add-environment-variables">Add environment variables</a>
 		- <a href="https://github.com/KF-Art/icewm-personal-tunning/#install-brillo-artix-only">Install Brillo (Artix only)</a>
  		- <a href="https://github.com/KF-Art/icewm-personal-tunning/#configuring-autostart">Configuring autostart</a>
  		- <a href="https://github.com/KF-Art/icewm-personal-tunning/#configuring-keybindings">Configuring Keybindings</a>
  		- <a href="https://github.com/KF-Art/icewm-personal-tunning/#configuring-icewm-preferences">Configuring IceWM Preferences</a>
  		- <a href="https://github.com/KF-Art/icewm-personal-tunning/#add-sudo-exceptions">Add sudo exceptions</a>
  		- <a href="https://github.com/KF-Art/icewm-personal-tunning/#installing-xed-text-editor-void-only">Installing Xed text editor (Void only)</a>
  			- <a href="https://github.com/KF-Art/icewm-personal-tunning/#automated-install-recommended">Automated install (recommended)</a>
  			- <a href="https://github.com/KF-Art/icewm-personal-tunning/#diy-method-1">DIY Method</a>
  		- <a href="https://github.com/KF-Art/icewm-personal-tunning/#theming-environment">Theming environment</a>
  			- <a href="https://github.com/KF-Art/icewm-personal-tunning/#customize-rofi">Customize Rofi</a>
  			- <a href="https://github.com/KF-Art/icewm-personal-tunning/#custom-bash-prompt">Custom Bash Prompt</a>
  			- <a href="https://github.com/KF-Art/icewm-personal-tunning/#install-san-francisco-pro-and-jetbrains-mono-fonts">Install San Francisco Pro and JetBrains Mono fonts</a>
  			- <a href="https://github.com/KF-Art/icewm-personal-tunning/#install-and-customize-materia-manjaro-dark-icewm-theme">Install and customize Materia Manjaro Dark IceWM theme</a>
  			- <a href="https://github.com/KF-Art/icewm-personal-tunning/#configure-qt5ct-and-set-GTK--kvantum-themes">Configure Qt5ct and set GTK & Kvantum themes</a>
  			- <a href="https://github.com/KF-Art/icewm-personal-tunning/#install-reversal-icon-theme">Install Reversal icon theme</a>
  			- <a href="https://github.com/KF-Art/icewm-personal-tunning/#prepare-betterlockscreen">Prepare Betterlockscreen</a>
  			- <a href="https://github.com/KF-Art/icewm-personal-tunning/#customize-xfce-panel">Customize XFCE panel</a>

<H1>Overview</H1>

IceWM is a lightweight window manager used on distributions like AntiX, but by default its very... W95-like. So I decided to customize at the maximum that I can. This is the result. 


Keybindings are processed via <code>sxhkd</code> instead of IceWM built-in one (because I didn't realized that IceWM already has its own script to setup keybindings, but you are free to use it). IceWM's taskbar were replaced by xfce4-panel, but you can also use the IceWM's one. Rofi is used as app launcher. Materia-Manjaro-Dark-B with some modifications is the selected WM theme. <code>lxappearance</code> and Qt5ct are used to customize desktop themes. 

I used Nemo as the default file manager, and Sakura is the selected terminal emulator (also I recommend QTerminal and <code>xfce4-terminal</code>). Here we'll use LXDM as a Display Manager.

This guide is focused on Void Linux and Artix Linux. Feel free to add or remove everything as you need and/or want in your setup. This is just a guide.

<H1>Special Thanks</H1>
- <a href="https://github.com/tuxliban">Tuxliban Torvalds</a> for contributing on simplify and optimize automated installation script, enabling services, Xed text editor installation process, and this guide.

<H1>To Do</H1>

- Add a Display Manager in order to get Polkit working correctly.
- Correct some guide content.
- Replace XFCE tools.
- Make wallpaper to work properly with Nemo Desktop (Artix only).
- Make automated script to detect signature error on package download and then, abort the installation.
- Fix Artix script (currently it's broken).
- Polish automated installation script.
- Replace some tools in order to keep the setup lightweight.

<H1>Automated Install (WIP)</H1>
There is a script that will install and configure everything what I explain in this guide. Note that is still in progress, so it may contain a lot of bugs or errors, so be careful.

Void Linux:
	
	sudo xbps-install -S git
	git -C "$HOME/github" clone https://github.com/KF-Art/icewm-personal-tunning
	cd icewm-personal-tunning
	chmod u+x automated_install_void.sh
	./automated_install_void.sh
	
Artix (currently broken, use at your own risk):

	sudo pacman -S git
	git -C "$HOME/github" clone https://github.com/KF-Art/icewm-personal-tunning
	cd icewm-personal-tunning
	chmod u+x automated_install_artix.sh
	./automated_install_artix.sh
	
After that, you can start your X session with <code>startx</code>.

<H1>DIY Method</H1>
Here, you will learn how to configure IceWM and tune it. Also, this is a explanation of the automated script's functioning.

To start, we will create a directory in which the cloned GitHub repositories will be saved.

	mkdir "$HOME/github"

<H1>Installing Yay and enabling Arch Linux support (Artix Only)</H1>
Into Artix, you will need to enable Arch Linux support and install Yay or any AUR helper. The last step will add extra, community and multilib Arch's repositories. If Artix repositories get more populated, this will not be necessary in the future.
	
    #Installing Yay
    pacman -S base-devel git
    git -C "$HOME/github" clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si

    #Enabling Arch Linux support
    pacman -S artix-archlinux-support
    git -C "$HOME/github" clone https://github.com/KF-Art/icewm-personal-tunning/ && cd icewm-personal-tunning
    
    # Add Arch Linux repos to pacman.conf. Hope that in the future this is not necessary.
    cat resources/pacman-arch-support.conf | sudo tee -a /etc/pacman.conf

<H1>Installing IceWM and base packages</H1>
At this point, I'm assuming that you already have your base system and Xorg installed. These packages are all the base to get all explained in this guide to work properly:

Void Linux:

    sudo xbps-install -S icewm rofi network-manager-applet sakura pa-applet brillo nemo qt5ct kvantum unzip zip bsdtar betterlockscreen sxhkd clementine xfce4-panel xfce4-whiskermenu-plugin xfce4-power-manager xfce4-clipman-plugin mate-polkit octoxbps notification-daemon playerctl numlockx picom xscreensaver setxkbmap xautolock blueman NetworkManager pulseaudio firefox pavucontrol git wget gedit eudev timeshift cronie bluez dbus lxdm
    
Artix:

    #Repositories packages.
    sudo pacman -S --needed icewm rofi network-manager-applet sakura nemo qt5ct kvantum-qt5 unzip zip bsdtar sxhkd clementine xfce4-panel xfce4-whiskermenu-plugin xfce4-power-manager xfce4-clipman-plugin mate-polkit octopi octopi-notifier-frameworks notification-daemon playerctl numlockx xscreensaver xorg-setxkbmap xautolock blueman networkmanager pulseaudio firefox pavucontrol git wget eudev cronie cronie-runit bluez dbus xed picom lxdm lxdm-runit
    
    #AUR packages.
    yay -Sa --needed pa-applet-git timeshift-bin betterlockscreen
    
<H2>Enabling services</H2>
Once installed, we have to enable services in order to have an X session, connectivity and Cron management. 


Void Linux:

	sudo ln -sf /etc/sv/{bluetoothd,NetworkManager,udevd,dbus,crond} /var/service
	
Artix: 

	sudo ln -sf /etc/runit/sv/{bluetoothd,NetworkManager,udevd,dbus,cronie} /run/runit/service/
    
From this point you can start your X session with <code>startx</code>.

<H2>Add environment variables</H2>
In order to make work XDEB and Qt5ct, you'll need to add some environment variables to your shell configuration file:

	QT_QPA_PLATFORMTHEME="qt5ct" #Allows qt5ct to manage Qt settings.

	#We'll use this when installing Xed via XDEB.
	export PATH="$PATH:$HOME/.local/share/bin"
	
<H2>Install Brillo (Artix only)</H2>
For some reason, the AUR package gives an error when compiling. So it's necessary to compile it manually. Also, you can replace it by <code>brightnessctl</code>, for example.

	wget https://gitlab.com/cameronnemo/brillo/-/archive/v1.4.9/brillo-v1.4.9.tar.gz
	tar -xvf brillo-v1.4.9.tar.gz
	cd brillo-v1.4.9
	make 
	sudo make install install.apparmor install.polkit DESTDIR="/"
   
<H2>Configuring Autostart</H2>
For some reason, IceWM ignores <code>~/.config/autostart</code> and <code>~/.config/autostart-scripts</code> configurations (at least on Void Linux). Fortunately, IceWM has its own built-in startup manager. We'll create a new file called <code>startup</code> inside <code>~/.icewm</code>.

    touch "$HOME/.icewm/startup"
    chmod u+x "$HOME/.icewm/startup"
   
Once created, we'll setup autostart commands and applications (yeah, I used <code>setxkbmap</code> to set keyboard map, but I recommend you to setup it with Xorg directly):

    #!/bin/bash
    pulseaudio --start &
    sxhkd &
    pa-applet &
    nm-applet &
    picom &
    numlockx &
    
    # In Void use octoxbps-notifier and in Artix, /usr/bin/octopi-notifier.
    octoxbps-notifier &
    # /usr/bin/octopi-notifier &
    
    xscreensaver -nosplash &
    xfce4-panel &
    nemo-desktop &
    setxkbmap latam
    /usr/libexec/notification-daemon &
    xautolock -detectsleep -time 5 -locker "betterlockscreen -l blur -w /path/to/your/wallpaper.png" -killtime 10 -killer "loginctl suspend"
    blueman-applet &!
    
Change <code>/path/to/your/wallpaper.png</code> by the path of your desired background for lockscreen. In this build, a wallpaper is included into resources folder.

Feel free to increase or decrease the <code>-killtime</code> (10 is the minimum) and <code>-time</code> amount.

<H2>Configuring Keybindings</H2>
As I said before, I used <code>sxhkd</code> to manage keybindings, but this should work similar on <code>~/.icewm/keys</code> (you need to create it and make it executable). We'll create a new file called <code>sxhkdrc</code>.

    touch "$HOME/.config/sxhkd/sxhkdrc"
    
Now we can configure our keybindings:

    #Media buttons
    XF86Audio{Prev,Next,Play,Pause}
	    playerctl {previous,next,play-pause,play-pause}

    #Volume Control
    XF86Audio{RaiseVolume,LowerVolume}
        pactl -- set-sink-volume 0 {+5%,-5%}

    #Mute button
    XF86AudioMute
        pactl set-sink-mute @DEFAULT_SINK@ toggle

    #Brightness control
    XF86MonBrightness{Down,Up}
	    sudo brillo {-U 20,-A 20}

    #Terminal emulator
    ctrl + alt + t
        sakura %u

    #File manager
    ctrl + alt + e
        nemo

    #Web browser
    ctrl + alt + w
        firefox

    #Music player
    ctrl + alt + q
        clementine

    #Lockscreen
    ctrl + alt + l
        betterlockscreen -l blur -w /path/to/your/wallpaper.png
        
<code>brillo</code> also needs elevated privileges to be able to change brightness, and also we'll add an exception for it. You can make writable the <code>brightness</code> file of your GPU (like as I did), in order to do it without superuser privileges, but I don't know what other consequences it can have.

<H2>Configuring IceWM Preferences</H2>
Again, we need to create a configuration file:
    
    touch "$HOME/.icewm/preferences"
    
And now setup the preferences:

    TaskBarShowWorkspaces=0
    ShowTaskBar=0
    RebootCommand="loginctl reboot"
    ShutdownCommand="loginctl poweroff"
    TerminalCommand=tilix
    SuspendCommand="loginctl suspend"

If you don't want to use XFCE's panel, set <code>ShowTaskBar</code> on <code>1</code>, and remove it from autostart.

<H2>Add sudo exceptions</H2>
<code>brillo</code> requires root privileges in order to edit the brightness and power status. To be able to use the related keybindings and startup commands, we have to add one exception to <code>sudoers</code> file. 

	sudo visudo

Now add this line at the end of the file (change <code>yourusername</code> for your user's name):
	
	yourusername ALL= NOPASSWD: /usr/bin/brillo
	
Alternatively, you can use the automated script method.

	echo "$USER $(cat /etc/hostname)= NOPASSWD: /usr/bin/brillo" | sudo EDITOR='tee -a' visudo
	
After that, logout. Related keybindings now should work.

<H2>Installing Xed text editor (Void only)</H2>
Xed is my favorite GTK text editor, so I included it into this build. I think that is strange that the Cinnamon's default text editor is not in the repositories of Void, because Cinnamon is one of the officially supported desktop environments. Into Artix this is not necessary, 'cause it's on the repositories.

<H3>Automated install (recommended)</H3>
The installation of Xed via XDEB is quite tedious, so I created a script to automate the task. First, clone this repo (if not done already):
	
	git -C "$HOME/github" clone https://github.com/KF-Art/icewm-personal-tunning/
	
Now you can run the installation script. Note that you will need a fully POSIX compatible shell, like <code>oksh</code> or <code>mksh</code>. In this script we'll use <code>dash</code> to avoid installing extra packages.

	cd icewm-personal-tunning/scripts/
	chmod u+x xed_void_install.sh
	./xed_void_install.sh
	
<H3>DIY Method</H3>
We'll take the official's Linux Mint package, convert it to XBPS and install it. But first, we need to install XDEB script (into automated script, the selected path is <code>~/.local/share/bin</code> to avoid errors.

	sudo xbps-install -S binutils tar curl xz
	git -C "$HOME/github" clone https://github.com/toluschr/xdeb
	chmod u+x $HOME/github/xdeb/xdeb
	sudo cp $HOME/github/xdeb/xdeb /usr/local/bin
	
Once installed, we can proceed to package conversion. Install XApps dependency from Void Linux's repository:

	sudo xbps-install -S xapps
	
Download DEB packages from official Linux Mint's repository:

	mkdir /tmp/xed && cd /tmp/xed

	# These commands will not work on Bash or ZSH, So the dash shell will be used temporarily.
	dash -c 'echo "xed_2.8.4+ulyssa_amd64.deb\nxed-common_2.8.4+ulyssa_all.deb\nxed-doc_2.8.4+ulyssa_all.deb"' >> xed_packages
	dash -c 'for i in $(cat xed_packages); do curl -O http://packages.linuxmint.com/pool/backport/x/xed/$i; done'
	
And convert them with XDEB:

	dash -c 'for i in $(cat xed_packages); do xdeb -Sde $i; done'
	
Finally, you can install them:

	sudo xbps-install -R binpkgs xed xed-common xed-doc
	
Xed needs its Glib schemas to be compiled. Otherwise, it will not work.

	sudo glib-compile-schemas /usr/share/glib-2.0/schemas

Now Xed should be working properly. If you want, delete the Gedit package. The automated script doesn't remove Gedit, in case Xed fails in the future.

	sudo xbps-remove -R gedit

<H2>Theming environment</H2>

<H3>Customize Rofi</H3>

We will use a theme based on Aditya Shakya's KDE KRunner one.

	# Clone this repo if not done yet.
	git -C $HOME/github clone https://github.com/KF-Art/icewm-personal-tunning/
	
	# Copy theme and launcher.
	mkdir $HOME/.config/rofi
	cp $HOME/github/icewm-personal-tunning/dotfiles/rofi/* $HOME/.config/rofi/

<H3>Custom Bash prompt</H3>
I made a custom Agnoster-like Bash prompt. With this you don't need Oh My Bash. Add this to your <code>~/.bashrc</code>:
	
	triangle=$'\uE0B0'

	export PS1='\[\e[48;5;237m\] \[\e[0;48;5;237m\]\u\[\e[0;48;5;237m\]@\[\e[0;48;5;237m\]\H\[\e[48;5;237m\] \[\e[0;38;5;237;48;5;29m\]$triangle\[\e[48;5;29m\] \[\e[0;48;5;29m\]\w\[\e[48;5;29m\] \[\e[0;38;5;29;48;5;24m\]$triangle\[\e[48;5;24m\] \[\e[0;48;5;24m\]\!\[\e[48;5;24m\] \[\e[0;38;5;24;48;5;42m\]$triangle\[\e[0;48;5;42m\] \[\e[0;38;5;234;48;5;42m\]\T\[\e[0;48;5;42m\] \[\e[0;38;5;42m\]$triangle \[\e[0m\]'
	

Edit it as much you want. Also, you can use a prompt generator to modify it, like <a href="https://github.com/Scriptim/bash-prompt-generator">the one made by Scriptim.</code>
	
<H3>Install San Francisco Pro and JetBrains Mono fonts</H3>
We need to clone the font repo, move fonts to <code>/usr/share/fonts/OTF</code>, and update fonts cache and list:

	#San Francisco Fonts
	git -C "$HOME/github" clone https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts
	sudo mkdir /usr/share/fonts/OTF
	sudo mv $HOME/github/San-Francisco-Pro-Fonts/*.otf /usr/share/fonts/OTF
	
	#JetBrains Mono
	mkdir /tmp/JetBrains-Mono && cd /tmp/JetBrains-Mono
	wget https://github.com/JetBrains/JetBrainsMono/releases/download/v2.242/JetBrainsMono-2.242.zip
	unzip JetBrainsMono-2.242.zip
	sudo cp fonts /usr/share
	
	#Update font cache and list
	fc-cache -fv; fc-list

<H3>Install and customize Materia Manjaro Dark IceWM theme</H3>
Download <a href=https://www.box-look.org/p/1393603/>Materia Manjaro Dark B</a> IceWM theme, and move it to <code>~/.icewm/themes/</code>. Now we have to edit theme file, specifically Srmx (<code>~/.icewm/themes/Materia-Manjaro-Dark-B/Srmx.theme</code>) to give it a custom fonts and wallpaper. Edit these lines like this:

	#Fonts
	TitleFontNameXft=                          "SF Pro Display:size=10"
	StatusFontNameXft=                         "SF Pro Display:size=10"
	MenuFontNameXft=                           "SF Pro Display:size=10"
	NormalTaskBarFontNameXft=                  "SF Pro Display:size=10"
	ActiveTaskBarFontNameXft=                  "SF Pro Display:size=10"
	ListBoxFontNameXft=                        "SF Pro Display:size=10"
	ToolTipFontNameXft=                        "SF Pro Display:size=10"
	QuickSwitchFontNameXft=                    "SF Pro Display:size=10"
	ClockFontNameXft=                          "SF Pro Display:size=10"

	#Desktop
	DesktopBackgroundImage=                   "/path/to/your/wallpaper.png"
	
Feel free to edit all the theme as you want (for example, color scheme).

<H3>Configure Qt5ct and set GTK & Kvantum themes</H3>
In order to use Qt5ct and manage Qt settings, it's necesary to add a environment variable to your <code>.zshrc</code> or <code>.bashrc</code> at the end of the file:

	QT_QPA_PLATFORMTHEME="qt5ct"
	
Alternatively, you can set this variable into <code>/etc/environment</code> to set it at system level. Logout to apply the changes (restart if you're setting it at system level). 
After that, open Qt5ct, set Kvantum style and configure fonts as you want (I recommend SF Pro Display Light 10).

Download your preferred GTK and Kvantum themes and copy them to <code>/usr/share/themes</code> and <code>~/.config/Kvantum/</code>, respectively. In this setup, I will use StarLabs-Green (GTK) and KvFlat-Emerald (Kvantum), but you can use any theme you want. 

	#KvFlat-Emerald installation
	git -C "$HOME/github" clone https://github.com/KF-Art/KvFlat-Emerald/
	cp "$HOME/github/KvFlat-Emerald/KvFlat-Emerald-Solid" "$HOME/.config/Kvantum"

Now open <code>lxappearance</code> & Kvantum, set themes and configure fonts (<code>lxappearance</code>).

<H3>Install Reversal icon theme</H3>
You can install any icon theme that you want, as long it includes a <code>void-distributor-logo</code> icon. In this case, I will use Reversal icon theme:
	
	git -C "$HOME/github" clone https://github.com/yeyushengfan258/Reversal-icon-theme
	cd "$HOME/github/Reversal-icon-theme"
	sudo ./install.sh -green
	
Now apply the icon theme at <code>lxappearance</code> and Qt5ct.

<H3>Prepare Betterlockscreen</H3>
Betterlockscreen needs your background to be cached before you can use it:

	betterlockscreen -u /path/to/your/wallpaper.png

<H3>Customize XFCE panel</H3>

I have leave the defaults in general. Delete the default start menu and add Whisker menu instead, change the icon to <code>void-distributor-logo</code> and change the label to "Void Linux". Lastly, add Power Manager and Clipman applets. 

<b>DON'T RUN <code>xfce4-power-manager</code> DAEMON, IT WILL DISABLE <code>sxhkd</code> BRIGHTNESS KEYBINDINGS</b>.
