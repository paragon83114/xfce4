#!/data/data/com.termux/files/usr/bin/bash

# --- DEFINICIÓN DE COLORES Y ESTILOS ---
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'
CHECK="[${GREEN}OK${RESET}]"
INFO="[${CYAN}INFO${RESET}]"

# Función para barra de carga estética
loading_bar() {
    echo -ne "${CYAN}Cargando: ${RESET}[P...................] \r"
    sleep 0.5
    echo -ne "${CYAN}Cargando: ${RESET}[ooooo...............] \r"
    sleep 0.5
    echo -ne "${CYAN}Cargando: ${RESET}[oooooooooo..........] \r"
    sleep 0.5
    echo -ne "${CYAN}Cargando: ${RESET}[ooooooooooooooo.....] \r"
    sleep 0.5
    echo -ne "${CYAN}Cargando: ${RESET}[oooooooooooooooooooo] \r"
    echo ""
}

clear
echo -e "${CYAN}╔═══════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║     INICIANDO ENTORNO XFCE4 TERMUX    ║${RESET}"
echo -e "${CYAN}╚═══════════════════════════════════════╝${RESET}"
echo ""

# --- PASO 1: LIMPIEZA PROFUNDA ---
echo -e "${INFO} Limpiando procesos y archivos temporales..."

# Matamos procesos en silencio
pkill -9 -f termux.x11 > /dev/null 2>&1
pkill -9 -f pulseaudio > /dev/null 2>&1
pkill -9 -f xfce4-session > /dev/null 2>&1
pkill -9 -f dbus-daemon > /dev/null 2>&1

# Borramos archivos 'lock'
rm -rf $PREFIX/var/run/pulseaudio > /dev/null 2>&1
rm -rf $PREFIX/tmp/pulseaudio* > /dev/null 2>&1
rm -rf $TMPDIR/.X11-unix > /dev/null 2>&1
rm -rf $TMPDIR/.X0-lock > /dev/null 2>&1

sleep 1
echo -e "${CHECK} Sistema limpio."

# --- PASO 2: AUDIO (SALIDA Y ENTRADA) ---
echo -e "${INFO} Iniciando servidor de Audio (PulseAudio)..."

# Iniciamos PulseAudio
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1 --daemonize=no > /dev/null 2>&1 &

export PULSE_SERVER=127.0.0.1

# Esperamos 4 segundos para asegurar que PulseAudio arranque
echo -ne "${YELLOW}Conectando Audio (Mic + Altavoz)... \r${RESET}"
sleep 4 

# 1. Cargamos el ALTAVOZ (Sink)
pactl load-module module-aaudio-sink > /dev/null 2>&1
# 2. Cargamos el MICRÓFONO (Source)
pactl load-module module-aaudio-source > /dev/null 2>&1

echo -e "${CHECK} Audio (In/Out) iniciado en 127.0.0.1"

# --- PASO 3: SERVIDOR GRÁFICO ---
echo -e "${INFO} Arrancando servidor gráfico X11..."
export XDG_RUNTIME_DIR=${TMPDIR}

termux-x11 :0 > /dev/null 2>&1 &

loading_bar

echo -e "${CHECK} Pantalla preparada."

# --- PASO 4: LANZAR APP ANDROID ---
echo -e "${INFO} Abriendo Termux:X11 en Android..."
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity > /dev/null 2>&1
sleep 1

# --- PASO 5: ESCRITORIO ---
echo -e "${INFO} Lanzando escritorio XFCE4..."

# Usamos nohup para mantenerlo limpio y en silencio
nohup env DISPLAY=:0 PULSE_SERVER=127.0.0.1 dbus-launch --exit-with-session xfce4-session > /dev/null 2>&1 &

echo -e "${CHECK} ¡Todo listo! Cerrando script..."
sleep 1
exit 0
