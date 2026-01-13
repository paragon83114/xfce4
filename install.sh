termux-change-repo
ln -s /storage/emulated/0/Linux storage/linux
pkg update
pkg upgrade -y -o Dpkg::Options::="--force-confnew"
pkg install tur-repo -y
pkg install x11-repo -y
pkg install termux-x11-nightly -y
pkg install pulseaudio -y
pkg install proot-distro -y
pkg install wget -y
pkg install git -y
pkg install xfce4 -y
pkg install chromium -y
#pkg install firefox -y
pkg install xfce4-pulseaudio-plugin -y
pkg install xfce4-whiskermenu-plugin -y
pkg install geany -y
pkg install code-oss -y
pkg install parole -y
pkg install nmap -y
pkg install termux-api -y
pkg list-all > paquetes.txt

mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
mkdir -p $HOME/.config/xfce4/desktop/

cp storage/linux/xfce4/xfce4-desktop.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
cp storage/linux/xfce4/xfce4-panel.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
cp storage/linux/xfce4/keyboard-layout.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml
cp storage/linux/xfce4/icons.screen0.yaml $HOME/.config/xfce4/desktop/icons.screen0.yaml

mkdir -p $HOME/Desktop
cp storage/linux/xfce4/*.desktop Desktop
chmod +x Desktop/*.desktop

cp storage/linux/termux_xfce4.sh .
cp storage/linux/backup.sh .
chmod +x *.sh
./termux_xfce4.sh
