#!/bin/bash
key(){
bash <(curl -fsSL cdn.jsdelivr.net/gh/P3TERX/SSH_Key_Installer@master/key.sh) -og ilay1678 -p 8071 -d
apt-get install ufw -y
ufw allow 8071
ufw allow https
ufw allow http
echo y | ufw enable
}

bbr(){
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr
}
caddy(){
apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | tee /etc/apt/trusted.gpg.d/caddy-stable.asc
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
apt update
apt install caddy
}

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
export PATH=$PATH:/usr/local/bin
show_menu() {
    echo -e "
    ${green}我若为王${plain} ${red}${plain}
    --- https://ifking.cn ---
    ${green}1.${plain}  一键开启ssh秘钥登录
    ${green}2.${plain}  v2ray脚本
    ${green}3.${plain}  LemonBench
    ${green}4.${plain}  superSpeed
    ${green}5.${plain}  流媒体解锁检测
    ${green}6.${plain}  superBench
    ${green}7.${plain}  安装docker
    ${green}8.${plain}  Debian开启bbr
    ${green}9.${plain}  安装Caddy
    ${green}10.${plain}  yabs
    ————————————————-
    ${green}0.${plain}  退出脚本
    "
    echo && read -p "请输入选择: " num

    case "${num}" in
    0)
        exit 0
        ;;
    1)
        key
        show_menu
        ;;
    2)
        bash <(curl -s -L https://github.961678.xyz/https://raw.githubusercontent.com/233boy/v2ray/master/install.sh)
        show_menu
        ;;
    3)
        curl -fsSL http://ilemonra.in/LemonBenchIntl | bash -s full
        show_menu
        ;;
    4)
        bash <(curl -Lso- https://cdn.jsdelivr.net/gh/CoiaPrant/Speedtest@main/speedtest-multi.sh)
        show_menu
        ;;      
    5)
        bash <(curl -sSL https://cdn.jsdelivr.net/gh/CoiaPrant/MediaUnlock_Test@main/check.sh)  
        show_menu
        ;; 
    6)
        bash <(wget -qO- https://down.vpsxb.net/superbench.sh)
        show_menu
        ;;      
    7)
        curl -fsSL https://get.docker.com | bash -s docker
        show_menu
        ;;    
    8)
        bbr
        show_menu
        ;;   
    9)
        caddy
        show_menu
        ;; 
    10)
        curl -sL yabs.sh | bash
        show_menu
        ;;       
    *)
        echo -e "${red}请输入正确的数字 [0-3]${plain}"
                show_menu
        ;;
    esac
}
show_menu
