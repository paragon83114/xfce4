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
echo -e "${CYAN}╔═════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║    XFCE4 + GPU ACCELERATION (ADRENO 730)    ║${RESET}"
echo -e "${CYAN}╚═════════════════════════════════════════════╝${RESET}"
echo ""

# --- PASO 1: LIMPIEZA PROFUNDA ---
echo -e "${INFO} Limpiando procesos y archivos temporales..."
pkill -9 -f termux.x11 > /dev/null 2>&1
pkill -9 -f pulseaudio > /dev/null 2>&1
pkill -9 -f xfce4-session > /dev/null 2>&1
pkill -9 -f dbus-daemon > /dev/null 2>&1
pkill -9 -f virgl_test_server_android > /dev/null 2>&1

rm -rf $PREFIX/var/run/pulseaudio > /dev/null 2>&1
rm -rf $PREFIX/tmp/pulseaudio* > /dev/null 2>&1
rm -rf $TMPDIR/.X11-unix > /dev/null 2>&1
rm -rf $TMPDIR/.X0-lock > /dev/null 2>&1

sleep 1
echo -e "${CHECK} Sistema limpio."

# --- PASO 2: AUDIO (PULSEAUDIO) ---
echo -e "${INFO} Iniciando servidor de Audio..."
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1 --daemonize=no > /dev/null 2>&1 &
export PULSE_SERVER=127.0.0.1
sleep 2 

# Cargar módulos de audio de Android
pactl load-module module-aaudio-sink > /dev/null 2>&1
pactl load-module module-aaudio-source > /dev/null 2>&1
echo -e "${CHECK} Audio (In/Out) listo."

# --- PASO 3: ACELERACIÓN GPU (VIRGL + TURNIP/ZINK) ---
echo -e "${INFO} Iniciando puente de aceleración GPU..."
# Lanzamos el servidor VirGL para Android en segundo plano
virgl_test_server_android & 

# Variables críticas para usar la GPU Adreno 730 via Zink (OpenGL sobre Vulkan)
export GALLIUM_DRIVER=zink
export MESA_LOADER_DRIVER_OVERRIDE=zink
export TU_DEBUG=nativeinline
export DISPLAY=:0

# --- PASO 4: SERVIDOR GRÁFICO X11 ---
echo -e "${INFO} Arrancando Termux:X11..."
export XDG_RUNTIME_DIR=${TMPDIR}
termux-x11 :0 > /dev/null 2>&1 &

loading_bar

# Abrir la aplicación Android automáticamente
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity > /dev/null 2>&1
sleep 2

# --- PASO 5: LANZAR ESCRITORIO ---
echo -e "${INFO} Lanzando entorno XFCE4 con aceleración activa..."
# Usamos dbus-launch para evitar errores de permisos y sesión
nohup dbus-launch --exit-with-session xfce4-session > /dev/null 2>&1 &

echo -e "${CHECK} ¡Todo listo! Pulsa la tecla de inicio para ver el escritorio."
echo ""
echo -e "${YELLOW}NOTA: Para verificar la GPU, abre una terminal en XFCE y escribe: glxinfo -B${RESET}"
sleep 2
exit 0
