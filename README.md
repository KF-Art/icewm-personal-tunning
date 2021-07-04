# IceWM Personal Tunning (WIP)
Personal customization of IceWM on mainly, Void Linux.

<H1>Overview</H1>

IceWM is a lightweight window manager used on distributions like AntiX, but by default its very... W95-like. So I decided to customize at the maximum that I can. This is the result. 


Keybindings are processed via <code>sxhkd</code> instead of IceWM built-in one (because I didn't realized that IceWM already has its own script to setup keybindings, but you are free to use it). IceWM's taskbar were replaced by xfce4-panel, but you can also use the IceWM's one. uLauncher is used as app launcher. Materia-Manjaro-Dark-B with some modifications is the selected WM theme. <code>lxappearance</code> and Qt5ct are used to customize desktop themes. I used Nemo as the default file manager, and Tilix is the selected terminal emulator (also I recommend QTerminal and <code>xfce4-terminal</code>).

This guide is focused on Void Linux, and in the future, Artix. Feel free to add or remove everything as you need and/or want in your setup. This is just a guide.}

<H1>To Do</H1>

- Get MATE Polkit agent to run at startup.
- Get Nemo's "Run as root" context menu option to work properly.
- Add dotfiles.
- Create automated installation script.

<H1>Installing IceWM and initial tools</H1>
At this point, I'm assuming that you already have your system and Xorg installed. These are just some initial tools, we will install the rest later.

    sudo xbps-install -S icewm ulauncher network-manager-applet pa-applet brillo nemo qt5ct kvantum betterlockscreen sxhkd clementine xfce4-panel xfce4-whiskermenu-plugin xfce4-power-manager xfce4-clipman-plugin mate-polkit octoxbps notification-daemon playerctl numlockx zzz compton xscreensaver setxkbmap xautolock blueman NetworkManager pulseaudio firefox pavucontrol git wget gedit
   
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
    octoxbps-notifier &
    xscreensaver -nosplash &
    xfce4-panel &
    nemo-desktop &
    ulauncher &
    setxkbmap latam
    /usr/libexec/notification-daemon &
    xautolock -detectsleep -time 5 -locker "betterlockscreen -l blur -w /path/to/your/wallpaper.png" -killtime 10 -killer "sudo zzz -z"
    blueman-applet &!
    
Change <code>/path/to/your/wallpaper.png</code> by the path of your desired background for lockscreen.

Probably, you realized that <code>xautolock</code> uses <code>sudo zzz -z</code> to suspend the system. Don't worry, we'll add an exception to <code>sudoers</code> to be able to do that.

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
    
Shutdown and Reboot commands are not working yet, because by default are configured to work with SystemD; working on it. 
If you don't want to use XFCE's panel, set <code>ShowTaskBar</code> on <code>1</code>, and remove it from autostart.

<H2>Add sudo exceptions</H2>
<code>brillo</code> and <code>zzz</code> requires root privileges in order to edit the brightness and power status. To be able to use the related keybindings and startup commands, we have to add two exceptions to <code>sudoers</code> file. 

	sudo visudo

Now add this line at the end of the file (change <code>yourusername</code> for your user's name):
	
	yourusername ALL= NOPASSWD: /usr/bin/zzz /usr/bin/brillo
	
After that, logout. Related keybindings and startup commands now should work.

<H2>[WIP] Installing Xed text editor (optional)</H2>
I think that is strange that the Cinnamon's text editor Xed is not in the repositories of Void, because Cinnamon is one of the officially supported desktop environments. 

<H3>Automated install (recommended)</H3>
The installation of Xed via XDEB is quite tedious, so I created a script to automate the task. First, clone this repo (if not done already):
	
	git clone https://github.com/KF-Art/icewm-personal-tunning/
	
Now you can run the installation script:

	cd icewm-personal-tunning/scripts/
	chmod u+x xed_void_install.sh
	./xed_void_install.sh
	
<H3>DIY Method</H3>
We'll take the official's Linux Mint package, convert it to XBPS and install it. But first, we need to install XDEB script.

	sudo xbps-install -S binutils tar curl xz
	git clone https://github.com/toluschr/xdeb
	cd xdeb
	chmod 0744 xdeb
	sudo cp xdeb /usr/local/bin
	
Once installed, we can proceed to package conversion. Install Xapps dependency from Void Linux's repository:

	sudo xbps-install -Sfy xapps
	
Download DEB packages from official Linux Mint's repository:

	mkdir xed && cd xed
	wget http://packages.linuxmint.com/pool/backport/x/xed/xed_2.8.4+ulyssa_amd64.deb
	wget http://packages.linuxmint.com/pool/backport/x/xed/xed-common_2.8.4+ulyssa_all.deb
	wget http://packages.linuxmint.com/pool/backport/x/xapp/xapps-common_2.0.7+ulyssa_all.deb
	wget http://packages.linuxmint.com/pool/backport/x/xed/xed-doc_2.8.4+ulyssa_all.deb
	
And convert them with XDEB (it only allows one operation per time, and that make the process quite tedious):

	xdeb -Sde xed_2.8.4+ulyssa_amd64.deb
	xdeb -Sde xed-common_2.8.4+ulyssa_all.deb
	xdeb -Sde xapps-common_2.0.7+ulyssa_all.deb
	xdeb -Sde xed-doc_2.8.4+ulyssa_all.deb
	
Finally, you can install them:

	sudo xbps-install --repository binpkgs xed-2.8.4_1 xed-common-2.8.4_1 xed-doc-2.8.4_1 xapps-common-2.0.7_1
	
If you want, delete the Gedit package (this is not included on automated script, because this is your decision):

	sudo xbps-remove -R gedit

<H2>Theming environment</H2>

<H3>Install Oh My ZSH or Oh My Bash (optional)</H3>
We will install one of these two and apply the Powerlevel9k (They say that Powerlevel10k is better, but I didn't configured it yet) and Agnoster themes, respectively.
	
	#Clone this repo in order to get dotfiles.
	git clone https://github.com/KF-Art/icewm-personal-tunning/
	
	#ZSH
	sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
	cp icewm-personal-icewm/dotfiles/shellrc/.zshrc ~/
	
	#BASH
	sh -c "$(wget https://raw.github.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"
	cp icewm-personal-icewm/dotfiles/shellrc/.bashrc ~/
	
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

Download your prefered GTK and Kvantum themes and copy them to <code>/usr/share/themes</code> and <code>~/.config/Kvantum/</code>, respectively. In this setup, I will use StarLabs-Green (GTK) and KvFlatManjaro (Kvantum), but you can use any theme you want. Now open <code>lxappearance</code> & Kvantum, set themes and configure fonts (<code>lxappearance</code>).

<H3>Install Reversal icon theme (optional)</H3>
You can install any icon theme that you want. In this case, I will use Reversal icon theme:
	
	git clone https://github.com/yeyushengfan258/Reversal-icon-theme
	cd Reversal-icon-theme
	sudo ./install.sh -a
	
Now apply the icon theme at <code>lxappearance</code> and Qt5ct.

<H3>Prepare Betterscreenlock</H3>
Betterscreenlock needs your background to be cached before you can use it:

	betterscreenlock -u -blur /path/to/your/wallpaper.png

<H3>Customize XFCE panel</H3>

I have leave the defaults in general. Delete the default start menu and add Whisker menu instead, change the icon to <code>void-distributor-logo</code> and change the label to "Void Linux". Lastly, add Power Manager and Clipman applets. 

<b>DON'T RUN <code>xfce4-power-manager</code> DAEMON, IT WILL DISABLE <code>sxhkd</code> BRIGHTNESS KEYBINDINGS</b>.
