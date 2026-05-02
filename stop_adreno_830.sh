#!/data/data/com.termux/files/usr/bin/bash

# --- CONFIGURACIÓN DE COLORES (PALETA NEÓN) ---
B_CYAN='\033[1;96m'
B_GREEN='\033[1;92m'
B_MAGENTA='\033[1;95m'
B_YELLOW='\033[1;93m'
B_RED='\033[1;91m'
WHITE='\033[1;97m'
GRAY='\033[0;90m'
RESET='\033[0m'

# Símbolos
CHECK="✔"
INFO="ℹ"
X_MARK="✖"
ARROW="➜"

# --- INTERFAZ VISUAL ---
header() {
    clear
    echo -e "${B_MAGENTA}┌──────────────────────────────────────────────────────────┐${RESET}"
    echo -e "${B_MAGENTA}│${B_CYAN}      XFCE4 ULTIMATE DESKTOP - ADRENO 830 ACCELERATED     ${B_MAGENTA}│${RESET}"
    echo -e "${B_MAGENTA}├──────────────────────────────────────────────────────────┤${RESET}"
    echo -e "${B_MAGENTA}│${WHITE}           DETENIENDO ENTORNO GRÁFICO SEGURO              ${B_MAGENTA}│${RESET}"
    echo -e "${B_MAGENTA}└──────────────────────────────────────────────────────────┘${RESET}"
    echo ""
}

log_status() {
    echo -e "${GRAY}[${2}${GRAY}]${RESET} ${1}"
}

loading_bar() {
    local duration=0.1
    echo -ne "${B_CYAN}${ARROW} Finalizando procesos: ${RESET}["
    for i in {1..20}; do
        echo -ne "${B_RED}■${RESET}"
        sleep $duration
    done
    echo -e "] ${B_GREEN}¡TERMINADO!${RESET}"
}

# --- 1. PROCESO DE DETENCIÓN ---
header

# Paso A: Intento de cierre elegante (opcional pero recomendado)
log_status "Enviando señal de cierre a XFCE..." "${B_YELLOW}${INFO}"
xfce4-session-logout --logout > /dev/null 2>&1
sleep 1

# Paso B: Matar procesos de Termux y la App de Android
log_status "Forzando cierre de Termux:X11 y Binarios..." "${B_RED}${X_MARK}"

# Matar la App de Android (com.termux.x11)
am force-stop com.termux.x11 > /dev/null 2>&1

# Matar procesos internos
for proc in termux.x11 pulseaudio xfce4-session dbus-daemon virgl_test_server_android xfconfd xfce4-panel xfdesktop; do
    pkill -9 -f "$proc" > /dev/null 2>&1
done

# Paso C: Limpieza de Sockets y Locks (Evita errores al reiniciar)
log_status "Limpiando sockets y archivos temporales..." "${B_CYAN}${INFO}"
rm -rf $PREFIX/var/run/pulseaudio > /dev/null 2>&1
rm -rf $PREFIX/tmp/pulseaudio* > /dev/null 2>&1
rm -rf $TMPDIR/.X11-unix > /dev/null 2>&1
rm -rf $TMPDIR/.X0-lock > /dev/null 2>&1
rm -f $TMPDIR/dbus-* > /dev/null 2>&1

# Animación de confirmación
loading_bar

echo ""
log_status "Entorno de memoria saneado y listo." "${B_GREEN}${CHECK}"
echo -e "${GRAY}Ya puedes cerrar Termux o iniciar una nueva sesión.${RESET}"

exit 0
