#!/data/data/com.termux/files/usr/bin/bash

# --- DEFINICIÓN DE COLORES Y ESTILOS ---
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'
CHECK="[${GREEN}OK${RESET}]"
INFO="[${CYAN}INFO${RESET}]"

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

exit 0
