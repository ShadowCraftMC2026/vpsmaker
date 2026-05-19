#!/bin/bash

# ==========================================
# SHADOWCRAFTMC ULTRA INSTALLER
# HACKER NEON + SOUND + VOICE EDITION
# ==========================================

# -------- COLORS --------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'

B_RED='\033[1;31m'
B_GREEN='\033[1;32m'
B_YELLOW='\033[1;33m'
B_BLUE='\033[1;34m'
B_PURPLE='\033[1;35m'
B_CYAN='\033[1;36m'
B_WHITE='\033[1;37m'

NC='\033[0m'

# -------- SOUND SYSTEM --------
beep() {
    printf "\a"
}

beep_success() {
    for i in {1..3}; do
        printf "\a"
        sleep 0.15
    done
}

boot_sound() {
    for i in {1..2}; do
        printf "\a"
        sleep 0.1
    done
}

# -------- VOICE SYSTEM --------
say() {
    if command -v espeak >/dev/null 2>&1; then
        espeak "$1" >/dev/null 2>&1
    elif command -v spd-say >/dev/null 2>&1; then
        spd-say "$1" >/dev/null 2>&1
    else
        echo -e "$1"
    fi
}

# -------- RAINBOW TEXT --------
rainbow() {
    colors=($RED $YELLOW $GREEN $CYAN $BLUE $PURPLE)
    text="$1"
    i=0
    for (( j=0; j<${#text}; j++ )); do
        c=${colors[$((i % ${#colors[@]}))]}
        echo -ne "${c}${text:$j:1}"
        ((i++))
    done
    echo -e "${NC}"
}

# -------- TYPE EFFECT --------
type_text() {
    text="$1"
    delay="${2:-0.01}"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# -------- LOADING --------
loading() {
    clear
    boot_sound

    echo -e "${B_CYAN}BOOTING SHADOWCRAFTMC SYSTEM...${NC}"
    echo -ne "${B_RED}["
    for i in {1..35}; do
        echo -ne "${B_GREEN}█${NC}"
        sleep 0.02
    done
    echo -e "${B_RED}]${NC}"

    echo -e "${B_WHITE}SYSTEM READY ✔${NC}"
    beep_success
    sleep 1
}

# -------- BANNER --------
banner() {
    clear
    echo -e "${B_RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    rainbow "   ███████╗██╗  ██╗ █████╗ ██████╗  ██████╗  ██████╗██████╗ "
    rainbow "   ██╔════╝██║  ██║██╔══██╗██╔══██╗██╔════╝ ██╔════╝██╔══██╗"
    rainbow "   ███████╗███████║███████║██║  ██║██║  ███╗██║     ██████╔╝"
    rainbow "   ╚════██║██╔══██║██╔══██║██║  ██║██║   ██║██║     ██╔══██╗"
    rainbow "   ███████║██║  ██║██║  ██║██████╔╝╚██████╔╝╚██████╗██║  ██║"
    rainbow "   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝"

    echo -e "${B_RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${B_WHITE}        SHADOWCRAFTMC INSTALLER v1.0${NC}"
    echo -e "${B_RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

pause() {
    echo ""
    echo -e "${B_WHITE}[${B_RED}ENTER${B_WHITE}] Continue...${NC}"
    read -r
}

# ================= TOOLS =================
tools_menu(){
    while true; do
        banner
        echo -e "${B_RED}──── TOOLS ────${NC}"
        echo -e "${B_CYAN}1) Root Access"
        echo -e "2) Tailscale"
        echo -e "3) Cloudflare DNS"
        echo -e "4) System Info"
        echo -e "5) Terminal"
        echo -e "6) Back${NC}"

        read -p "Select → " t
        case $t in
            1) bash <(curl -s URL_HERE) ;;
            2) bash <(curl -s URL_HERE) ;;
            3) bash <(curl -s URL_HERE) ;;
            4) bash <(curl -s URL_HERE) ;;
            5) bash <(curl -s URL_HERE) ;;
            6) return ;;
        esac
        pause
    done
}

# ================= PANELS =================
panels_menu(){
    while true; do
        banner
        echo -e "${B_RED}──── PANELS ────${NC}"
        echo -e "${B_GREEN}1) Pterodactyl Panel"
        echo -e "2) Air-Link Panel"
        echo -e "3) Back${NC}"

        read -p "Select → " p
        case $p in
            1)
                echo -e "${B_GREEN}Launching Pterodactyl Installer...${NC}"
                bash <(curl -fsSL https://ptero.shadowcoding.qzz.io)
                ;;
            2)
                bash <(curl -fsSL URL_HERE)
                ;;
            3) return ;;
        esac
        pause
    done
}

# ================= MAIN =================
loading

while true; do
    banner
    echo -e "${B_RED}──────── MAIN MENU ────────${NC}"
    echo -e "${B_CYAN}A) Panels"
    echo -e "B) VPS Maker"
    echo -e "C) Tools"
    echo -e "D) Exit${NC}"

    read -p "Select → " c

    case ${c,,} in
        a) panels_menu ;;
        b)
            echo -e "${B_GREEN}Starting VPS Maker...${NC}"
            bash <(curl -fsSL URL_HERE)
            pause
            ;;
        c) tools_menu ;;
        d)
            echo -e "${B_RED}Exiting ShadowCraftMC Installer...${NC}"

            beep_success
            say "Thanks for using ShadowCraftMC Installer. Enjoy"

            type_text "Goodbye Commander..." 0.05

            exit 0
            ;;
    esac
done
