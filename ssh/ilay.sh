#!/bin/bash
key(){
bash <(curl -fsSL git.io/key.sh) -og ilay1678 -p 8071 -d
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
    ${green}3.${plain}  哪吒面板脚本
    ${green}4.${plain}  LemonBench
    ${green}5.${plain}  superSpeed
    ${green}6.${plain}  流媒体解锁检测
    ${green}7.${plain}  superBench
    ${green}8.${plain}  安装docker
    ${green}9.${plain}  Debian开启bbr
    ${green}10.${plain}  PortForward安装
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
        ;;
    2)
        bash <(curl -s -L https://git.io/v2ray.sh)
        ;;
    3)
        bash <(curl -s -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh)
        ;;
    4)
        curl -fsSL http://ilemonra.in/LemonBenchIntl | bash -s fast
        ;;
    5)
        bash <(curl -Lso- https://git.io/superspeed)
        ;;      
    6)
        bash <(curl -sSL "https://github.com/CoiaPrant/MediaUnlock_Test/raw/main/check.sh")  
        ;; 
    7)
        wget -qO- --no-check-certificate https://raw.githubusercontent.com/oooldking/script/master/superbench.sh | bash  
        ;;      
    8)
        curl -fsSL https://get.docker.com | bash -s docker
        ;;    
    9)
        bbr
        ;;   
    10)
        bash <(curl -s -L https://github.961678.xyz/https://gist.githubusercontent.com/ilay1678/c994ed4b0598f7f3c685a6a395d8bbb5/raw/install.sh)
        ;;   
    *)
        echo -e "${red}请输入正确的数字 [0-3]${plain}"
                show_menu
        ;;
    esac
}
show_menu
