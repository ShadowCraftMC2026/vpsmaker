#!/bin/bash

# =============================================
# PANEL WINGS INSTALLER - ShadowCraftMC EDITION
# =============================================

# --- Colors ---
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

# ===== BASE64 DECODE =====
b64d() { echo "$1" | base64 -d; }

# ===== BASE64 DATA =====

# Banner
BANNER_B64="X19fXyAgICBfICAgXyAgICAgIF8gICAgICBfX19fICAgICBfX18gICBfXyAgICAgICAgX18KLyBfX198ICB8IHwgfCB8ICAgIC8gXCAgICB8ICBfIFwgICAvIF8gXCAgXCBcICAgICAgLyAvClxfX18gXCAgfCB8X3wgfCAgIC8gXyBcICAgfCB8IHwgfCB8IHwgfCB8ICBcIFwgL1wgLyAvIAogX19fKSB8IHwgIF8gIHwgIC8gX19fIFwgIHwgfF98IHwgfCB8X3wgfCAgIFwgViAgViAvICAKfF9fX18vICB8X3wgfF98IC9fLyAgIFxfXCB8X19fXy8gICBcX19fLyAgICAgXF8vXF8v"

# URLs
ROOT_B64="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L3Zwc21ha2VyL3JlZnMvaGVhZHMvbWFpbi90b29scy9yb290LnNo"
TAIL_B64="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L3Zwc21ha2VyL3JlZnMvaGVhZHMvbWFpbi90b29scy9UYWlsc2NhbGUuc2g="
CF_B64="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L3Zwc21ha2VyL3JlZnMvaGVhZHMvbWFpbi90b29scy9jbG91ZGZsYXJlLnNo"
SYS_B64="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L3Zwc21ha2VyL3JlZnMvaGVhZHMvbWFpbi90b29scy9TWVNURU0uc2g="
VPS_B64="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L3Zwc21ha2VyL3JlZnMvaGVhZHMvbWFpbi90b29scy92cHMuc2g="
TERM_B64="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L3Zwc21ha2VyL3JlZnMvaGVhZHMvbWFpbi90b29scy90ZXJtaW5hbC5zaA=="
RDP_B64="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L3Zwc21ha2VyL3JlZnMvaGVhZHMvbWFpbi90b29scy9yZGIuc2g="

PTERO_B64="cHRlcm8uc2hhZG93Y29kaW5nLnF6ei5pbw=="
AIR_B64="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L3Zwc21ha2VyL3JlZnMvaGVhZHMvbWFpbi90b29scy9BaXJMaW5rLnNo"
VPS_B64="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L3Zwc21ha2VyL3JlZnMvaGVhZHMvbWFpbi90b29scy92cG1ha2Vy"

# ===== FUNCTIONS =====

animate_text() {
    text="$1"; delay="${2:-0.01}"
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"; sleep "$delay"
    done
    echo ""
}

loading_bar() {
    clear
    echo -e "${B_RED}Initializing ShadowCraftMC Installer...${NC}"
    echo -ne "${B_RED}[${NC}"
    for i in {1..40}; do echo -ne "${B_WHITE}█${NC}"; sleep 0.02; done
    echo -e "${B_RED}]${NC}"
    sleep 1
}

pause() { read -p "Press Enter..." ; }

banner() {
    clear
    echo -e "${B_RED}"
    b64d "$BANNER_B64"
    echo -e "${NC}"
    echo -e "${B_WHITE}ShadowCraftMC Installer${NC}"
}

# ===== MENUS =====

tools_menu(){
while true; do
    banner
    echo "1) Root"
    echo "2) Tailscale"
    echo "3) Cloudflare"
    echo "4) System"
    echo "5) VPS"
    echo "6) Terminal"
    echo "7) RDP"
    echo "8) Back"
    read -p "→ " t

    case $t in
      1) bash <(curl -s "$(b64d "$ROOT_B64")");;
      2) bash <(curl -s "$(b64d "$TAIL_B64")");;
      3) bash <(curl -s "$(b64d "$CF_B64")");;
      4) bash <(curl -s "$(b64d "$SYS_B64")");;
      5) bash <(curl -s "$(b64d "$VPS_B64")");;
      6) bash <(curl -s "$(b64d "$TERM_B64")");;
      7) bash <(curl -s "$(b64d "$RDP_B64")");;
      8) return;;
    esac
done
}

# ===================== PANELS MENU (Part A) =====================
panels_menu() {
    while true; do
        banner
        echo -e "${B_RED}────────────── PANELS MENU ─────────────${NC}"
        echo -e "${B_RED} 1)${B_WHITE} Pterodactyl Panel"
        echo -e "${B_RED} 2)${B_WHITE} Air-Link Panel"
        echo -e "${B_RED} 3)${B_WHITE} Back to Main Menu"
        echo -e "${B_RED}────────────────────────────────────────${NC}"
        
        read -p "Select → " p
        case $p in
            1) 
                echo -e "${B_GREEN}Starting Pterodactyl Installer...${NC}"
                bash <(curl -fsSL "$(b64d "$PTERO_B64")")
                ;;
            2) 
                echo -e "${B_GREEN}Starting Air-Link Installer...${NC}"
                bash <(curl -s "$(b64d "$AIR_B64")")
                ;;
            3) return ;;
            *) echo -e "${B_RED}Invalid Option${NC}"; sleep 1 ;;
        esac
        pause
    done
}

# ===================== MAIN MENU =====================
# Run Loading Bar Once
loading_bar

while true; do
    banner
    # Animated Main Menu Options
    echo -e "${B_RED}────────────── MAIN MENU ──────────────${NC}"
    echo -e "${B_RED} A)${B_WHITE} Panel"
    echo -e "${B_RED} B)${B_WHITE} Vps Maker"
    echo -e "${B_RED} C)${B_WHITE} Tools"
    echo -e "${B_RED} D)${B_WHITE} System Edit (Coming Soon)"
    echo -e "${B_RED} E)${B_WHITE} Exit"
    echo -e "${B_RED}──────────────────────────────────────${NC}"
    
    # animate_text "Select an option:" 0.02
    read -p "Select → " choice

    # Convert to lowercase to handle A/a
    case ${choice,,} in
        a)
            panels_menu
            ;;
        b)
            echo -e "${B_GREEN}Launching VPS Maker...${NC}"
            bash <(curl -s "$(b64d "$VPS_B64")")
            pause
            ;;
        c)
            tools_menu
            ;;
        d)
            echo -e "${B_YELLOW}"
            animate_text ">>> System Edit feature is Coming Soon! <<<" 0.05
            echo -e "${NC}"
            sleep 1
            ;;
        e)
            echo -e "${B_GREEN}Thank you for using ShadowCraftMC Installer!${NC}"
            animate_text "Exiting..." 0.05
            exit 0
            ;;
        *)
            echo -e "${B_RED}Invalid selection. Please try again.${NC}"
            sleep 1
            ;;
    esac
done
