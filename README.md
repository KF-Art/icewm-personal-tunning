# IceWM Personal Tunning (WIP)
Personal customization of IceWM on mainly, Void Linux and Artix Runit. Note that other inits are not supported in this guide.

<H1>Overview</H1>

IceWM is a lightweight window manager used on distributions like AntiX, but by default its very... W95-like. So I decided to customize at the maximum that I can. This is the result. 


Keybindings are processed via <code>sxhkd</code> instead of IceWM built-in one (because I didn't realized that IceWM already has its own script to setup keybindings, but you are free to use it). IceWM's taskbar were replaced by xfce4-panel, but you can also use the IceWM's one. uLauncher is used as app launcher. Materia-Manjaro-Dark-B with some modifications is the selected WM theme. <code>lxappearance</code> and Qt5ct are used to customize desktop themes. 

I used Nemo as the default file manager, and Tilix is the selected terminal emulator (also I recommend QTerminal and <code>xfce4-terminal</code>). Here we'll use <code>xinit</code> to access to X session, but you are free to install any display manager of your choice (like LXDM).

This guide is focused on Void Linux, and in the future, Artix. Feel free to add or remove everything as you need and/or want in your setup. This is just a guide.

<H1>Special Thanks</H1>
- <a href="https://github.com/tuxliban">Tuxliban Torvalds</a> for contributing on simplify and optimize enabling services and Xed text editor process. 

<H1>To Do</H1>

- Make MATE Polkit agent to run at startup.
- Make Nemo's "Run as root" context menu option to work properly.
- Make the script detect existing files and folders.
- Correct some guide content.
- Make wallpaper to work properly with Nemo Desktop.
- Add XFCE's panel configuration files.
- Make automated script to detect signature error on package download and then, abort the installation.
- Add Artix guide and automated script.
- Create Musl, Lightweight (Void and Artix) and Lightweight-Musl branches.
- Polish automated installation script.

<H1>Automated Install (WIP)</H1>
There is a script that will install and configure everything what I explain in this guide. Note that is still in progress, so it may contain some bugs or errors.

Void Linux:
	
	sudo xbps-install -S git
	git clone https://github.com/KF-Art/icewm-personal-tunning
	cd icewm-personal-tunning
	chmod u+x automated_install_void.sh
	./automated_install_void.sh
	
Artix:

	sudo pacman -S git
	git clone https://github.com/KF-Art/icewm-personal-tunning
	cd icewm-personal-tunning
	chmod u+x automated_install_artix.sh
	./automated_install_artix.sh
	
After that, you can start your X session with <code>startx</code>.

<H1>DIY Method</H1>
Here, you will learn how to configure IceWM and tune it. Also, this is a explanation of the automated script's functioning.

<H1>Installing Yay and enabling Arch Linux support (Artix Only)</H1>
Into Artix, you will need to enable Arch Linux support and install Yay or any AUR helper. 
	
    #Installing Yay
    pacman -S base-devel git
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si

    #Enabling Arch Linux support
    pacman -S artix-archlinux-support
    git clone https://github.com/KF-Art/icewm-personal-tunning/ && cd icewm-personal-tunning
    
    # Add Arch Linux repos to pacman.conf. Hope that in the future this is not necessary.
    cat resources/pacman-arch-support.conf | sudo tee -a /etc/pacman.conf

<H1>Installing IceWM and base packages</H1>
At this point, I'm assuming that you already have your base system and Xorg installed. These packages are all the base to get all explained in this guide to work properly:

Void Linux:

    sudo xbps-install -S icewm ulauncher network-manager-applet tilix pa-applet brillo nemo qt5ct zsh kvantum unzip zip tar betterlockscreen sxhkd clementine xfce4-panel xfce4-whiskermenu-plugin xfce4-power-manager xfce4-clipman-plugin mate-polkit octoxbps notification-daemon playerctl numlockx compton xscreensaver setxkbmap xautolock blueman NetworkManager pulseaudio firefox pavucontrol git wget gedit eudev timeshift cronie xinit bluez dbus zzz-user-hooks
    
Artix:

    #Repositories packages.
    sudo pacman -S --needed icewm network-manager-applet tilix nemo qt5ct zsh kvantum-qt5 unzip zip tar sxhkd clementine xfce4-panel xfce4-whiskermenu-plugin xfce4-power-manager xfce4-clipman-plugin mate-polkit octopi octopi-notifier-frameworks notification-daemon playerctl numlockx xscreensaver xorg-setxkbmap xautolock blueman networkmanager pulseaudio firefox pavucontrol git wget eudev cronie cronie-runit xorg-xinit bluez dbus xed
    
    #AUR packages.
    yay -Sa --needed ulauncher pa-applet-git timeshift-bin betterlockscreen compton-old-git
    
<H2>Enabling services</H2>
Once installed, we have to enable services in order to have an X session, connectivity and Cron management. 


Void Linux:

	sudo ln -s /etc/sv/{bluetoothd,NetworkManager,udevd,dbus,crond} /var/service
	
Artix: 

	sudo ln -s /etc/runit/sv/{bluetoothd,NetworkManager,udevd,dbus,cronie} /run/runit/service/
    
From this point you can start your X session with <code>startx</code>.

<H2>Add environment variables</H2>
In order to make work some applications like Tilix and Qt5ct, we'll need to add some environment variables to your shell configuration file:

	QT_QPA_PLATFORMTHEME="qt5ct" #Allows qt5ct to manage Qt settings.

	#Tilix's VTE compatibility
	if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        	source /etc/profile.d/vte.sh
	fi

	#We'll use this when installing Xed via XDEB.
	export PATH=$PATH:~/.local/share/bin
	
<H2>Install Brillo (Artix only)</H2>
For some reason, the AUR package gives an error when compiling. So it's necessary to compile it manually.

	wget https://gitlab.com/cameronnemo/brillo/-/archive/v1.4.9/brillo-v1.4.9.tar.gz
	tar -xvf brillo-v1.4.9.tar.gz
	cd brillo-v1.4.9
	make 
	sudo make install install.apparmor install.polkit DESTDIR="/"
   
<H2>Configuring Autostart</H2>
For some reason, IceWM ignores <code>~/.config/autostart</code> and <code>~/.config/autostart-scripts</code> configurations (at least on Void Linux). Fortunately, IceWM has its own built-in startup manager. We'll create a new file called <code>startup</code> inside <code>~/.icewm</code>.

    touch ~/.icewm/startup
    chmod +x ~/.icewm/startup
   
Once created, we'll setup autostart commands and applications (yeah, I used <code>setxkbmap</code> to set keyboard map, but I recommend you to setup it with Xorg directly):

    #!/bin/bash
    pulseaudio --start &
    sxhkd &
    pa-applet &
    nm-applet &
    compton &
    numlockx &
    
    #In Void use octoxbps-notifier and in Artix, /usr/bin/octopi-notifier.
    octoxbps-notifier &
    # /usr/bin/octopi-notifier &
    
    xscreensaver -nosplash &
    xfce4-panel &
    nemo-desktop &
    ulauncher &
    setxkbmap latam
    /usr/libexec/notification-daemon &
    xautolock -detectsleep -time 5 -locker "betterlockscreen -l blur -w /path/to/your/wallpaper.png" -killtime 10 -killer "zzz -z"
    blueman-applet &!
    
Change <code>/path/to/your/wallpaper.png</code> by the path of your desired background for lockscreen. In this build, a wallpaper is included into resources folder.

Feel free to increase or decrease the <code>-killtime</code> (10 is the minimum) and <code>-time</code> amount.

<H2>Configuring Keybindings</H2>
As I said before, I used <code>sxhkd</code> to manage keybindings, but this should work similar on <code>~/.icewm/keys</code> (you need to create it and make it executable). We'll create a new file called <code>sxhkdrc</code>.

    touch ~/.config/sxhkd/sxhkdrc
    
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
        tilix %u

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
    
    touch ~/.icewm/preferences
    
And now setup the preferences:

    TaskBarShowWorkspaces=0
    ShowTaskBar=0
    RebootCommand="loginctl reboot"
    ShutdownCommand="loginctl poweroff"
    TerminalCommand=tilix
    SuspendCommand="sudo zzz -z"

<code>zzz</code> also needs elevated privileges to be able to change the power status, and we'll add an exception to <code>sudoers</code> for it. There's a package called <code>zzz-user-hooks</code>, but I didn't achieve to make it work.  

If you don't want to use XFCE's panel, set <code>ShowTaskBar</code> on <code>1</code>, and remove it from autostart.

<H2>Add sudo exceptions</H2>
<code>brillo</code>requires root privileges in order to edit the brightness and power status. To be able to use the related keybindings and startup commands, we have to add one exception to <code>sudoers</code> file. 

	sudo visudo

Now add this line at the end of the file (change <code>yourusername</code> for your user's name):
	
	yourusername ALL= NOPASSWD: /usr/bin/brillo
	
Alternatively, you can use the automated script method. Create a group and make an exception to <code>sudoers</code>.

	sudo groupadd brillo
	sudo usermod -aG brillo $USER
	echo '%brillo ALL=(ALL) NOPASSWD: /usr/bin/brillo /usr/bin/zzz' | sudo 	EDITOR='tee -a' visudo
	
After that, logout. Related keybindings and startup commands now should work.

<H2>Installing Xed text editor (Void only)</H2>
Xed is my favorite GTK text editor, so I included it into this build. I think that is strange that the Cinnamon's text editor Xed is not in the repositories of Void, because Cinnamon is one of the officially supported desktop environments. 

<H3>Automated install (recommended)</H3>
The installation of Xed via XDEB is quite tedious, so I created a script to automate the task. First, clone this repo (if not done already):
	
	git clone https://github.com/KF-Art/icewm-personal-tunning/
	
Now you can run the installation script. Note that you will need a POSIX compatible shell, like <code>oksh</code> or <code>mksh</code>. In this script we'll use <code>sh</code> to avoid installing extra packages.

	cd icewm-personal-tunning/scripts/
	chmod u+x xed_void_install.sh
	./xed_void_install.sh
	
<H3>DIY Method</H3>
We'll take the official's Linux Mint package, convert it to XBPS and install it. But first, we need to install XDEB script (into automated script, the selected path is <code>~/.local/share/bin</code> to avoid errors.

	sudo xbps-install -S binutils tar curl xz
	git clone https://github.com/toluschr/xdeb
	cd xdeb
	chmod u+x xdeb
	sudo cp xdeb /usr/local/bin
	
Once installed, we can proceed to package conversion. Install Xapps dependency from Void Linux's repository:

	sudo xbps-install -S xapps
	
Download DEB packages from official Linux Mint's repository:

	mkdir xed && cd xed
	printf "xed_2.8.4+ulyssa_amd64.deb\nxed-common_2.8.4+ulyssa_all.deb\nxed-doc_2.8.4+ulyssa_all.deb" >> xed_packages
	for i in $(cat xed_packages); do curl -O http://packages.linuxmint.com/pool/backport/x/xed/$i; done
	
And convert them with XDEB:

	for i in $(cat xed_packages); do xdeb -Sde $i; done
	
Finally, you can install them:

	sudo xbps-install --repository binpkgs xed-2.8.4_1 xed-common-2.8.4_1 xed-doc-2.8.4_1
	
Xed needs its Glib schemas to be compiled. Otherwise, it will not work.

	sudo glib-compile-schemas /usr/share/glib-2.0/schemas

Now Xed should be working properly.

If you want, delete the Gedit package. The automated script doesn't remove Gedit, in case Xed fails in the future.

	sudo xbps-remove -R gedit

<H2>Theming environment</H2>

<H3>Custom Bash prompt</H3>
I made a custom Agnoster-like Bash prompt. With this you don't need Oh My Bash. Add this to your <code>~/.bashrc</code>:
	
	triangle=$'\uE0B0'

	export PS1='\[\e[48;5;237m\] \[\e[0;48;5;237m\]\u\[\e[0;48;5;237m\]@\[\e[0;48;5;237m\]\H\[\e[48;5;237m\] \[\e[0;38;5;237;48;5;29m\]$triangle\[\e[48;5;29m\] \[\e[0;48;5;29m\]\w\[\e[48;5;29m\] \[\e[0;38;5;29;48;5;24m\]$triangle\[\e[48;5;24m\] \[\e[0;48;5;24m\]\!\[\e[48;5;24m\] \[\e[0;38;5;24;48;5;42m\]$triangle\[\e[0;48;5;42m\] \[\e[0;38;5;234;48;5;42m\]\T\[\e[0;48;5;42m\] \[\e[0;38;5;42m\]$triangle \[\e[0m\]'
	

Edit it as much you want. Also, you can use a prompt generator to modify it, like <a href="https://github.com/Scriptim/bash-prompt-generator">the one made by Scriptim.</code>
	
<H3>Install San Francisco Pro and JetBrains Mono fonts</H3>
We need to clone the font repo, move fonts to <code>/usr/share/fonts/OTF</code>, and update fonts cache and list:

	#San Francisco Fonts
	git clone https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts
	cd San-Francisco-Pro-Fonts
	sudo mkdir /usr/share/fonts/OTF
	sudo mv *.otf /usr/share/fonts/OTF
	cd ..
	
	#JetBrains Mono
	mkdir JetBrains-Mono && cd JetBrains-Mono
	wget https://github.com/JetBrains/JetBrainsMono/releases/download/v2.225/JetBrainsMono-2.225.zip
	unzip JetBrainsMono-2.225.zip
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
	
Alternatively, you can set this variable into <code>/etc/environment</code> to set it at system level. Logout to apply the changes. 
After that, open Qt5ct, set Kvantum style and configure fonts as you want (I recommend SF Pro Display Light 10).

Download your preferred GTK and Kvantum themes and copy them to <code>/usr/share/themes</code> and <code>~/.config/Kvantum/</code>, respectively. In this setup, I will use StarLabs-Green (GTK) and KvFlat-Emerald (Kvantum), but you can use any theme you want. 

	#KvFlat-Emerald installation
	git clone https://github.com/KF-Art/KvFlat-Emerald/
	cd KvFlat-Emerald
	cp KvFlat-Emerald-Solid ~/.config/Kvantum

Now open <code>lxappearance</code> & Kvantum, set themes and configure fonts (<code>lxappearance</code>).

<H3>Install Reversal icon theme</H3>
You can install any icon theme that you want, as long it includes a <code>void-distributor-logo</code> icon. In this case, I will use Reversal icon theme:
	
	git clone https://github.com/yeyushengfan258/Reversal-icon-theme
	cd Reversal-icon-theme
	sudo ./install.sh -a
	
Now apply the icon theme at <code>lxappearance</code> and Qt5ct.

<H3>Prepare Betterlockscreen</H3>
Betterlockscreen needs your background to be cached before you can use it:

	betterlockscreen -u -blur /path/to/your/wallpaper.png

<H3>Customize XFCE panel</H3>

I have leave the defaults in general. Delete the default start menu and add Whisker menu instead, change the icon to <code>void-distributor-logo</code> and change the label to "Void Linux". Lastly, add Power Manager and Clipman applets. 

<b>DON'T RUN <code>xfce4-power-manager</code> DAEMON, IT WILL DISABLE <code>sxhkd</code> BRIGHTNESS KEYBINDINGS</b>.
