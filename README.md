# IceWM Personal Tunning (WIP)
Personal customization of IceWM on mainly, Void Linux.

<H1>Overview</H1>
IceWM is a lightweight window manager used on distributions like AntiX, but by default its very... W95-like. So I decided to customize at the maximum that I can. This is the result. 

Keybindings are processed via <code>sxkhd</code> instead of IceWM built-in one (because I didn't realized that IceWM already has its own script to setup keybindings, but you are free to use it). IceWM's taskbar were replaced by xfce4-panel, but you can also use the IceWM's one. uLauncher is used as app launcher. Materia-Manjaro-Dark-B with some modifications is the selected WM theme. <code>lxappearance</code> and Qt5ct are used to customize desktop themes. I used Nemo as the default file manager, and Tilix is the selected terminal emulator (also I recommend QTerminal and <code>xfce4-terminal</code>).

This guide is focused on Void Linux, and in the future, Artix. Feel free to add or remove everything as you need and/or want in your setup. This is just a guide.

<H1>Installing IceWM and initial tools</H1>
At this point, I'm assuming that you already have your system and Xorg installed. These are just some initial tools, we will install the rest later.

    sudo xbps-install -S icewm ulauncher network-manager-applet pa-applet brillo nemo qt5ct kvantum betterlockscreen sxhkd clementine xfce4-panel xfce4-whiskermenu-plugin octoxbps notification-daemon playerctl numlockx zzz compton xscreensaver setxkbmap xautolock blueman NetworkManager pulseaudio firefox pavucontrol git
   
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
        
<code>brillo</code> also needs elevated privileges to be able to change brightness, and also we'll add an exception for it. You can make writable the <code>brightness</code> file of your GPU (like as I did), in order to do it without superuses privileges, but I don't know what other consequences it can have.

<H2>Configuring IceWM Preferences</H2>
Again, we need to create a configuration file:
    
    touch ~/.icewm/preferences
    
And now setup the preferences:

    TaskBarShowWorkspaces=0
    ShowTaskBar=0
    RebootCommand="loginctl reboot"
    ShutdownCommand="loginctl poweroff"
    TerminalCommand=tilix
    SuspendCommand="zzz -z"
    
Shutdown and Reboot commands are not working yet, because by default are configured to work with SystemD; working on it. 
If you don't want to use XFCE's panel, set <code>ShowTaskBar</code> on <code>1</code>, and remove it from autostart.

<H2>Add sudo exceptions</H2>
<code>brillo</code> and <code>zzz</code> requires root privileges in order to edit the brightness and power status. To be able to use the related keybindings and startup commands, we have to add two exceptions to <code>sudoers</code> file. 

	sudo visudo

Now add this line at the end of the file (change <code>yourusername</code> for your user's name):
	
	yourusername ALL= NOPASSWD: /usr/bin/zzz /usr/bin/brillo
	
After that, logout. Related keybindings and startup commands now should work.

<H2>Theming environment</H2>

<H3>Install San Francisco Pro Fonts</H3>
We need to clone the font repo, move fonts to <code>/usr/share/fonts/OTF</code>, and update fonts cache and list:

	git clone https://github.com/sahibjotsaggu/San-Francisco-Pro-Fonts
	cd San-Francisco-Pro-Fonts
	sudo mkdir /usr/share/fonts/OTF
	sudo mv *.otf /usr/share/fonts/OTF
	fc-cache -fv; fc-list

<H3>Install and customize Materia Manjaro Dark IceWM theme</H3>
Download <a href=https://www.box-look.org/p/1393603/>Materia Manjaro Dark B</a> IceWM theme, and move it to <code>~/.icewm/themes/</code>. Now we have to edit theme file (Srmx variant, in my case) to give it a custom fonts and wallpaper. Edit these lines like this:

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
	
