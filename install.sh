termux-change-repo
termux-setup-storage
pkg update
pkg upgrade -y -o Dpkg::Options::="--force-confnew"
pkg install tur-repo -y
pkg install x11-repo -y
pkg install termux-x11-nightly -y
pkg install pulseaudio -y
pkg install wget -y
pkg install git -y
pkg install xfce4 -y
pkg install chromium -y
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
mkdir -p $HOME/Desktop

cp Config/xfce4-desktop.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
cp Config/xfce4-panel.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
cp Config/keyboard-layout.xml $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml
cp Config/icons.screen0.yaml $HOME/.config/xfce4/desktop/icons.screen0.yaml
cp Config/*.desktop $HOME/Desktop
chmod a+x $HOME/Desktop/*.desktop

#Es posible que este for solo se pueda ejecutar con el xfce4 encendido
for f in $HOME/Desktop/*.desktop; do
    gio set "$f" metadata::xfce-exe-checksum "$(sha256sum "$f" | awk '{print $1}')"
done

termux-x11-preference "fullscreen":"true"

echo "$HOME/xfce4/termux_xfce4" >> $HOME/.bashrc
chmod +x $HOME/.bashrc

chmod +x *.sh
./termux_xfce4.sh
