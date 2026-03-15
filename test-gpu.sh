#!/data/data/com.termux/files/usr/bin/bash

# Colores para la terminal
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

echo -e "${CYAN}--- PREPARANDO BENCHMARK GPU (SIN V-SYNC) ---${RESET}"

# 1. Instalación de paquetes necesarios
echo -e "${YELLOW}[1/3] Instalando glmark2...${RESET}"
pkg update -y
pkg install glmark2 -y

# 2. Configuración de variables de entorno
# vblank_mode=0 desactiva el límite de los hercios de la pantalla
export vblank_mode=0
export GALLIUM_DRIVER=zink
export MESA_LOADER_DRIVER_OVERRIDE=zink
export TU_DEBUG=nativeinline

echo -e "${GREEN}[2/3] Configuración de drivers completada.${RESET}"
echo -e "${CYAN}[3/3] Iniciando prueba de rendimiento bruto...${RESET}"
echo -e "${YELLOW}Nota: El benchmark se abrirá en tu ventana de Termux:X11${RESET}"

# 3. Ejecución del benchmark
# Usamos la versión de escritorio de glmark2
glmark2

echo -e "${GREEN}Prueba finalizada.${RESET}"
