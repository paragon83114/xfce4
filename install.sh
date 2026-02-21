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
pkg install xfce4-pulseaudio-plugin -y
pkg install xfce4-whiskermenu-plugin -y
pkg install geany -y
pkg install code-oss -y
pkg install parole -y
pkg install nmap -y
pkg install termux-api -y
pkg install openjdk-17 -y
pkg install gimp -y
pkg install firefox -y
pkg install chromium -y
pkg list-all > paquetes.txt

rm -R $HOME/.config/xfce4
mkdir -p $HOME/.config/xfce4/desktop/
cp Config/xfce4.tar.gz $HOME/.config
cd $HOME/.config
tar xvfz ./xfce4.tar.gz 

termux-x11-preference "fullscreen":"true"
termux-x11-preference "showAdditionalKbd":"false"
termux-x11-preference "displayResolutionMode":"custom"
termux-x11-preference "displayResolutionCustom":"1280x800"
#termux-x11-preference "displayResolutionCustom":"1440x900"
#termux-x11-preference "displayResolutionCustom":"1680x1050"
#termux-x11-preference "displayResolutionCustom":"1920x1200"
#termux-x11-preference "displayResolutionCustom":"2560x1600"
#termux-x11-preference "displayResolutionCustom":"2880x1800"

echo "alias start=$HOME/xfce4/start.sh" >> $HOME/.bashrc
echo "alias stop=$HOME/xfce4/stop.sh" >> $HOME/.bashrc
chmod +x $HOME/.bashrc

chmod +x $HOME/xfce4/*.sh
