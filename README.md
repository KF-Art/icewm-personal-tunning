# IceWM Personal Tunning (WIP)
Personal customization of IceWM on mainly, Void Linux.

<H1>Overview</H1>
IceWM is a lightweight window manager used on distributions like AntiX, but by default its very... W95-like. So I decided to customize at the maximum that I can. This is the result. Keybindings are processed via <code>sxkhd</code> instead of IceWM built-in one (because I didn't realized that IceWM already has its own script to setup keybindings, but you are free to use it). IceWM's taskbar were replaced by xfce4-panel, but you can also use the IceWM's one. uLauncher is used as app launcher. Materia-Manjaro-Dark-B with some modifications is the selected WM theme. <code>lxappearance</code> and Qt5ct are used to customize desktop themes. I used Nemo as the default file manager, and Tilix is the selected terminal emulator (also I reccomend QTerminal and <code>xfce4-terminal</code>).

<H1>Installing IceWM and initial tools</H1>
At this point, I'm assuming that you already have your system and Xorg installed.

    sudo xbps-install -S icewm ulauncher network-manager-applet pa-applet brillo nemo qt5ct kvantum betterlockscreen sxhkd clementine xfce4-panel xfce4-whiskermenu-plugin octoxbps
