#!/bin/bash

# ============================
#  Firewall de Defensa - Kali
# ============================
# Autor: Ruben Guerrero Muñoz - 2025
# Usa iptables
# ============================

# Ejecución con SUDO:
# sudo ./defensa.sh

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

# Ruta de log
LOGFILE="/var/log/defensa_firewall.log"

function log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOGFILE
}

function banner() {
    clear
    echo -e "${CYAN}"
    echo "======================================="
    echo "  AUTO FIREWALL DE DEFENSA PARA KALI"
    echo "======================================="
    echo -e "${NC}"
}

function ayuda() {
    echo -e "${YELLOW}[+] Guía rápida de uso:${NC}"
    echo
    echo -e " ${GREEN}1) Nivel 1 (Protección básica)${NC}"
    echo "    - Bloquea todo el tráfico entrante excepto:"
    echo "       - Conexiones establecidas"
    echo "       - SSH (22), HTTP (80) y HTTPS (443)"
    echo "    - Permite todo el tráfico saliente."
    echo
    echo -e " ${GREEN}2) Nivel 2 (Protección estricta)${NC}"
    echo "    - Bloquea todo el tráfico entrante."
    echo "    - Permite únicamente tráfico saliente y local (loopback)."
    echo
    echo -e " ${GREEN}3) Restaurar configuración inicial${NC}"
    echo "    - Limpia todas las reglas."
    echo "    - Restaura políticas a: INPUT/OUTPUT/FORWARD = ACCEPT."
    echo
    echo -e " ${GREEN}4) Ver reglas actuales${NC}"
    echo "    - Muestra en pantalla las reglas activas con detalle."
    echo
    echo -e " ${GREEN}0) Salir${NC}"
    echo "    - Cierra el script sin aplicar cambios."
    echo
    echo -e "${CYAN} [i] Consejo:${NC} Siempre ejecuta este script como root con:"
    echo -e "   ${YELLOW}sudo ./defensa.sh${NC}"
    echo
}

function analizar_puertos() {
    echo -e "${CYAN}[*] Análisis de puertos abiertos (ss):${NC}"
    ss -tulnp | grep LISTEN || echo "   Ningún puerto en escucha detectado."
    echo
    echo -e "${CYAN}[*] Escaneo rápido con nmap (puertos comunes):${NC}"
    nmap -F localhost | grep open || echo "   Ningún puerto abierto detectado."
    echo
}

function nivel1() {
    banner
    echo -e "${YELLOW}[*] Antes de aplicar Nivel 1:${NC}"
    analizar_puertos

    echo -e "${YELLOW}[*] Aplicando Nivel 1 (Protección básica)...${NC}"

    iptables -F
    iptables -X

    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    iptables -A INPUT -p tcp --dport 443 -j ACCEPT

    echo -e "${GREEN}[+] Nivel 1 aplicado.${NC}"
    log_action "Nivel 1 aplicado"

    echo -e "${YELLOW}[*] Después de aplicar Nivel 1:${NC}"
    analizar_puertos
}

function nivel2() {
    banner
    echo -e "${YELLOW}[*] Antes de aplicar Nivel 2:${NC}"
    analizar_puertos

    echo -e "${YELLOW}[*] Aplicando Nivel 2 (Protección estricta)...${NC}"

    iptables -F
    iptables -X

    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

    echo -e "${GREEN}[+] Nivel 2 aplicado.${NC}"
    log_action "Nivel 2 aplicado"

    echo -e "${YELLOW}[*] Después de aplicar Nivel 2:${NC}"
    analizar_puertos
}

function restaurar() {
    banner
    echo -e "${YELLOW}[*] Restaurando configuración inicial...${NC}"

    iptables -F
    iptables -X
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT

    echo -e "${GREEN}[+] Configuración restaurada.${NC}"
    log_action "Configuración restaurada"

    echo -e "${YELLOW}[*] Estado de puertos tras restaurar:${NC}"
    analizar_puertos
}

function ver_reglas() {
    banner
    echo -e "${CYAN}[*] Reglas actuales de iptables:${NC}"
    iptables -L -v -n --line-numbers
    log_action "Visualización de reglas actuales"
}

function menu() {
    banner
    ayuda
    echo -e "${YELLOW}Selecciona una opción:${NC}"
    echo "1) Nivel 1 (Protección básica)"
    echo "2) Nivel 2 (Protección estricta)"
    echo "3) Restaurar configuración inicial"
    echo "4) Ver reglas actuales"
    echo "0) Salir"
    echo
    read -p "[+] Opción: " opcion

    case $opcion in
        1) nivel1 ;;
        2) nivel2 ;;
        3) restaurar ;;
        4) ver_reglas ;;
        0) exit 0 ;;
        *) echo -e "${RED}[!] Opción no válida${NC}" ;;
    esac
}

# Bucle infinito hasta salir
while true; do
    menu
    echo
    read -p "Presiona [ENTER] para continuar..." temp
done
