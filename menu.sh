#!/bin/bash
clear

export GREEN='\e[32m'
export RED='\033[0;31m'
export BGBLUE='\e[1;44m'
export ORANGE='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export BG='\E[44;1;39m'
export NC='\033[0;37m'
export WHITE='\033[0;37m'
export local_version=$(cat /home/ver)  
export server_version=$(curl -sS "https://sshxvpn.me/MULTIPORTS/version")

export TRY="[${RED} * ${NC}]"

function status(){
    clear
get_status() {
    local service_name=$1
    local status=$(systemctl status "$service_name" | awk '/Active:/ {print $3}' | tr -d '()')
    
    if [[ $status == "running" ]]; then
        echo -e " • ${GREEN}ONLINE${NC}"
    else
        echo -e " • ${RED}OFFLINE${NC}"
    fi
}


# Get status for each service
openssh_status=$(get_status ssh)
stunnel5_status=$(get_status stunnel4)
dropbear_status=$(get_status dropbear)
slowdns_c_status=$(get_status client)
slowdns_s_status=$(get_status server)
ssh_ws_status=$(get_status ws-stunnel)
ss_status=$(get_status xray)
nginx_status=$(get_status nginx)
udp_status=$(get_status udp-custom)

## status qos
sshxvpn_status=$(get_status sshxvpn)

DESCRIPTION=$(lsb_release -sd)
CODENAME=$(lsb_release -sc)
KERNEL=$(uname -r)
COUNTRY=$(curl -s "https://ipinfo.io/city")
PUBLIC_IP=$(curl -s https://api.ipify.org)
ORG=$(curl -s "https://ipinfo.io/org")

echo -e "$BLUE┌────────────────────────────────────────────────────┐$NC"
echo -e "$BLUE│$NC $BG              • VPS & VPN PANEL MENU •            $NC $BLUE│$NC"
echo -e "$BLUE└────────────────────────────────────────────────────┘$NC"
echo -e "$BLUE┌────────────────────────────────────────────────────┐$NC"
echo -e "$BLUE│$NC IP VPS  : $PUBLIC_IP"
echo -e "$BLUE│$NC COUNTRY : $COUNTRY"
echo -e "$BLUE│$NC ORG     : $ORG"
echo -e "$BLUE│$NC OS      : $DESCRIPTION"
echo -e "$BLUE│$NC COD     : $CODENAME"
echo -e "$BLUE│$NC KERNEL  : $KERNEL"
echo -e "$BLUE└────────────────────────────────────────────────────┘$NC"
echo -e "$BLUE┌────────────────────────────────────────────────────┐$NC"
echo -e "$BLUE│$NC • Service\t\t\t\t • Status"
echo -e "$BLUE•────────────────────────────────────────────────────•$NC"
echo -e "$BLUE│$NC • OpenSSH\t\t\t\t$openssh_status\t\t"
echo -e "$BLUE│$NC • Stunnel5\t\t\t\t$stunnel5_status\t\t"
echo -e "$BLUE│$NC • Dropbear\t\t\t\t$dropbear_status\t\t"
echo -e "$BLUE│$NC • Client (SlowDNS)\t\t\t$slowdns_c_status\t\t"
echo -e "$BLUE│$NC • Server (SlowDNS)\t\t\t$slowdns_s_status\t\t"
echo -e "$BLUE│$NC • Websocket\t\t\t\t$ssh_ws_status\t\t"
echo -e "$BLUE│$NC • Xray Core\t\t\t\t$ss_status\t\t"
echo -e "$BLUE│$NC • Nginx\t\t\t\t$nginx_status\t\t"
echo -e "$BLUE│$NC • Udp Custom\t\t\t\t$udp_status\t\t"
echo -e "$BLUE•────────────────────────────────────────────────────•$NC"
echo -e "$BLUE│$NC • Data Limit\t\t\t\t$sshxvpn_status\t\t"
echo -e "$BLUE└────────────────────────────────────────────────────┘$NC"
echo -e "$BLUE•────────────────────────────────────────────────────•$NC"
echo -e ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
}

lajuker(){
clear
echo -e "$BLUE┌────────────────────────────────────────────────────┐$NC"
echo -e "$BLUE│$NC $BG              • VPS & VPN PANEL MENU •            $NC $BLUE│$NC"
echo -e "$BLUE└────────────────────────────────────────────────────┘$NC"
echo -e "$BLUE┌────────────────────────────────────────────────────┐$NC"
speedtest
echo -e "$BLUE└────────────────────────────────────────────────────┘$NC"
echo -e "$BLUE•────────────────────────────────────────────────────•$NC"
echo -e ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
}


update(){
clear
echo -e "$BLUE┌────────────────────────────────────────────────────┐$NC"
echo -e "$BLUE│$NC $BG              • VPS & VPN PANEL MENU •            $NC $BLUE│$NC"
echo -e "$BLUE└────────────────────────────────────────────────────┘$NC"
echo -e "$BLUE┌────────────────────────────────────────────────────┐$NC"
echo -e "$BLUE│$NC $TRY Checking For Updates.."
wget -qO- https://sshxvpn.me/MULTIPORTS/update.sh | bash
echo "$server_version" > /home/ver
echo -e "$BLUE│$NC $TRY Update Successfully.."
echo -e "$BLUE└────────────────────────────────────────────────────┘$NC"
echo -e "$BLUE•────────────────────────────────────────────────────•$NC"
echo -e ""
read -n 1 -s -r -p "  Press any key to back on menu"
menu
}

DB="/etc/xray/users"
if [ ! -d "$DB" ]; then
    mkdir -p "$DB"
    touch /etc/xray/users/ssh.txt
    touch /etc/xray/users/vmess.txt
    touch /etc/xray/users/vless.txt
    touch /etc/xray/users/trojan.txt
    touch /etc/xray/users/socks.txt
fi


clear
ssh=$(wc -l < /etc/xray/users/ssh.txt)
vm=$(wc -l < /etc/xray/users/vmess.txt)
vl=$(wc -l < /etc/xray/users/vless.txt)
tr=$(wc -l < /etc/xray/users/trojan.txt)
ss=$(wc -l < /etc/xray/users/socks.txt)

get_status() {
    local service_name=$1
    local status=$(systemctl status "$service_name" | awk '/Active:/ {print $3}' | tr -d '()')
    
    if [[ $status == "running" ]]; then
        echo -e "$GREEN[RUN]$NC"
    else
        echo -e "$RED[OFF]$NC"
    fi
}

SSHWS=$(get_status ssh)
NGINX=$(get_status nginx)
XR=$(get_status xray)

echo -e "$BLUE┌────────────────────────────────────────────────────┐$NC"
echo -e "$BLUE│$NC $BG              • VPS & VPN PANEL MENU •            $NC $BLUE│$NC"
echo -e "$BLUE└────────────────────────────────────────────────────┘$NC"
echo -e "$BLUE┌────────────────────────────────────────────────────┐$NC"
echo -e "$BLUE│$NC  SSHWS : ${SSHWS}     XRAY : ${XR}     NGINX : ${NGINX}  $BLUE│$NC"
echo -e "$BLUE└────────────────────────────────────────────────────┘$NC"
echo -e "$BLUE┌────────────────────────────────────────────────────•$NC"
echo -e "$BLUE│$NC ${BLUE}•${NC} IPVPS     : $(curl -sS ipv4.icanhazip.com)"
echo -e "$BLUE│$NC ${BLUE}•${NC} DOMAIN    : $(cat /etc/xray/domain)"
echo -e "$BLUE│$NC ${BLUE}•${NC} UPTIME    : $(uptime -p | sed 's/up //')"
echo -e "$BLUE└────────────────────────────────────────────────────•$NC"
echo -e "$BLUE┌────────────────────────────────────────────────────•$NC"
echo -e "$BLUE│$NC SSH/DNS     SOCKS     VMESS     VLESS     TROJAN"
echo -e "$BLUE│$NC    $RED${ssh}$NC          $RED${ss}$NC         $RED${vm}$NC         $RED${vl}$NC          $RED${tr}$NC"
echo -e "$BLUE└────────────────────────────────────────────────────•$NC"
echo -e "$BLUE┌────────────────────────────────────────────────────•$NC"
echo -e "$BLUE│$NC ${BLUE}[01]${NC} ${ORANGE}•${NC} ${WHITE}SSH & SLOWDNS${NC}        ${BLUE}[04]${NC} ${ORANGE}•${NC} ${WHITE}XRAY TROJAN WS${NC}"
echo -e "$BLUE│$NC ${BLUE}[02]${NC} ${ORANGE}•${NC} ${WHITE}XRAY VMESS WS${NC}        ${BLUE}[05]${NC} ${ORANGE}•${NC} ${WHITE}XRAY SOCKSS WS${NC}"
echo -e "$BLUE│$NC ${BLUE}[03]${NC} ${ORANGE}•${NC} ${WHITE}XRAY VLESS WS${NC}"
echo -e "$BLUE└────────────────────────────────────────────────────•$NC"
echo -e "$BLUE•────────────────────────────────────────────────────┐$NC"
echo -e "  ${BLUE}[06]${NC} ${ORANGE}•${NC} ${WHITE}DOMAIN PANEL${NC}         ${BLUE}[10]${NC} ${ORANGE}•${NC} ${WHITE}BACKUP PANEL${NC}    $BLUE│$NC"
echo -e "  ${BLUE}[07]${NC} ${ORANGE}•${NC} ${WHITE}CUSTOM DNS${NC}           ${BLUE}[11]${NC} ${ORANGE}•${NC} ${WHITE}SPEEDTEST VPS${NC}   $BLUE│$NC"
echo -e "  ${BLUE}[08]${NC} ${ORANGE}•${NC} ${WHITE}VPS SETTINGS${NC}         ${BLUE}[12]${NC} ${ORANGE}•${NC} ${WHITE}LOGIN LIMIT${NC}     $BLUE│$NC"
echo -e "  ${BLUE}[09]${NC} ${ORANGE}•${NC} ${WHITE}NOTIF PANEL${NC} "
echo -e "$BLUE•────────────────────────────────────────────────────┘${NC}"
echo -e "$BLUE┌────────────────────────────────────────────────────┐${NC}"
echo -e "$BLUE│$NC ${BLUE}[00]${NC} ${ORANGE}•${NC} ${RED}REBOOT SERVER${NC}        ${BLUE}[99]${NC} ${ORANGE}•${NC} ${RED}SERVER STATUS${NC}   $BLUE│$NC"
echo -e "$BLUE└────────────────────────────────────────────────────┘${NC}"

if [[ $server_version > $local_version ]]; then
    update_c="update"
    echo -e "${RED}┌────────────────────────────────────────────────────┐${NC}"
    echo -e "${RED}│${NC} ${RED}[100]${NC} • Update available: V$server_version"
    echo -e "${RED}└────────────────────────────────────────────────────┘${NC}"
else
    update_c="menu"
fi

echo -e "$BLUE┌────────────────────────────────•${NC}"
echo -e "$BLUE│$NC ${ORANGE}•${NC} VERSION  : ${BLUE}SC V24 / V$(cat /home/ver)${NC}"
echo -e "$BLUE│$NC ${ORANGE}•${NC} TELEGRAM : ${BLUE}@DOTYCAT${NC}"
echo -e "$BLUE│$NC ${ORANGE}•${NC} YOUTUBE  : ${BLUE}@SSHXVPN${NC}"
echo -e "$BLUE└────────────────────────────────•${NC}"
echo -e "$BLUE•────────────────────────────────────────────────────•$NC"
echo -e ""
echo -ne " Select menu : "; read opt
case $opt in
00 | 0) clear ; reboot ;;
01 | 1) clear ; ssh ;;
02 | 2) clear ; vmess ;;
03 | 3) clear ; vless ;;
04 | 4) clear ; trojan ;;
05 | 5) clear ; socks ;;
06 | 6) clear ; domain ;;
08 | 7) clear ; dns ;;
08 | 8) clear ; settings ;;
09 | 9) clear ; tele ;;
10) clear ; backup ;;
11) clear ; lajuker ;;
12) clear ; multi ;;
99) clear ; status ;;
100) clear ; $update_c ;;
*) clear ; menu ;;
esac
