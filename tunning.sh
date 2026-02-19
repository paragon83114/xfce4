
#Es posible que este for solo se pueda ejecutar con el xfce4 encendido
for f in $HOME/Desktop/*.desktop; do
    gio set "$f" metadata::xfce-exe-checksum "$(sha256sum "$f" | awk '{print $1}')"
done

termux-x11-preference "fullscreen":"true"
termux-x11-preference "showAdditionalKbd":"false"
termux-x11-preference "displayResolutionMode":"custom"
termux-x11-preference "displayResolutionExact":"1280x800"
