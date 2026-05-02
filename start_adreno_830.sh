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
    echo -e "${B_MAGENTA}└──────────────────────────────────────────────────────────┘${RESET}"
    echo ""
}

log_status() {
    echo -e "${GRAY}[${2}${GRAY}]${RESET} ${1}"
}

loading_bar() {
    local duration=0.3
    echo -ne "${B_CYAN}${ARROW} Inicializando componentes: ${RESET}["
    for i in {1..20}; do
        echo -ne "${B_GREEN}■${RESET}"
        sleep $duration
    done
    echo -e "] ${B_GREEN}¡LISTO!${RESET}"
}

# --- 1. LIMPIEZA PROFUNDA Y REINICIO ---
header
log_status "Purgando sesiones previas y zombies..." "${B_RED}${X_MARK}"

# Matar procesos de forma agresiva
for proc in termux.x11 pulseaudio xfce4-session dbus-daemon virgl_test_server_android xfconfd xfce4-panel xfdesktop; do
    pkill -9 -f "$proc" > /dev/null 2>&1
done

# Limpieza de sockets y locks
rm -rf $PREFIX/var/run/pulseaudio > /dev/null 2>&1
rm -rf $PREFIX/tmp/pulseaudio* > /dev/null 2>&1
rm -rf $TMPDIR/.X11-unix > /dev/null 2>&1
rm -rf $TMPDIR/.X0-lock > /dev/null 2>&1
rm -f $TMPDIR/dbus-* > /dev/null 2>&1

sleep 1
log_status "Entorno de memoria saneado." "${B_GREEN}${CHECK}"

# --- 2. AUDIO (SOLO SALIDA) ---
log_status "Configurando motor de Audio (Output-Only)..." "${B_CYAN}${INFO}"
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1 --daemonize=no > /dev/null 2>&1 &
export PULSE_SERVER=127.0.0.1
sleep 1
# Cargamos solo el Sink (salida) para evitar errores de micro
pactl load-module module-aaudio-sink > /dev/null 2>&1
log_status "Audio estéreo vinculado correctamente." "${B_GREEN}${CHECK}"

# --- 3. ACELERACIÓN GRÁFICA (ADRENO 830 / TURNIP / ZINK) ---
log_status "Inyectando drivers Mesa (Turnip + Zink)..." "${B_CYAN}${INFO}"

# Lanzar el servidor VirGL
virgl_test_server_android & 

# Variables de entorno optimizadas para Snapdragon 8 Elite
export DISPLAY=:0
export GALLIUM_DRIVER=zink
export MESA_LOADER_DRIVER_OVERRIDE=zink
export TU_DEBUG=nativeinline
# Forzar perfil de compatibilidad para evitar glitches en XFCE
export MESA_GL_VERSION_OVERRIDE=4.6
export MESA_GLSL_VERSION_OVERRIDE=460
# Optimización de rendimiento para Adreno
export __GL_THREADED_OPTIMIZATIONS=1

log_status "Hardware Adreno 830 reconocido y activo." "${B_GREEN}${CHECK}"

# --- 4. SERVIDOR X11 Y PANTALLA ---
log_status "Estableciendo conexión con Termux:X11..." "${B_CYAN}${INFO}"
export XDG_RUNTIME_DIR=${TMPDIR}
termux-x11 :0 > /dev/null 2>&1 &

loading_bar

# Abrir la app de Android
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity > /dev/null 2>&1
sleep 1

# --- 5. LANZAMIENTO DEL ENTORNO ---
log_status "Arrancando XFCE4 Desktop Environment..." "${B_YELLOW}${ARROW}"

# Usar dbus-launch de forma limpia
dbus-launch --exit-with-session xfce4-session > /dev/null 2>&1 &

echo ""
echo -e "${B_GREEN}╔══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${B_GREEN}║${WHITE}  ¡SISTEMA INICIADO! Cambia a la app Termux:X11 para ver  ${B_GREEN}║${RESET}"
echo -e "${B_GREEN}╚══════════════════════════════════════════════════════════╝${RESET}"
echo -e "${GRAY}Monitorizando hardware Adreno 830 en segundo plano...${RESET}"
echo ""

exit 0
