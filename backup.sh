cp .config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml storage/linux/xfce4
cp .config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml storage/linux/xfce4
cp .config/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml storage/linux/xfce4
cp .config/xfce4/desktop/icons.screen0.yaml storage/linux/xfce4

rm storage/linux/xfce4/*.desktop
cp Desktop/*.desktop storage/linux/xfce4

cp backup.sh storage/linux
cp install.sh storage/linux
cp termux_xfce4.sh storage/linux

#tar chromium.tar.gz .config/chromium
