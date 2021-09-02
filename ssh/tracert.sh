#!/bin/bash
curl -s --connect-timeout 4 -m 10 http://ip-api.com/json/ | grep -q -i "China"
if [[ $? == 0 ]];then
	curl -s --connect-timeout 4 -m 10 http://ip-api.com/json/ | grep -q -i "hk"
	if [[ $? != 0 ]];then
		echo
		echo "中国大陆的服务器无需检测,不用看,肯定很优秀!!"
		echo
		exit;
	fi
fi

cat /etc/issue | grep -q "Ubuntu"
if [[ $? == 0 ]];then
    echo -e "\n\033[1;32m[Info] Ubuntu Update\033[0m";sleep 2s
    sudo apt update
    sudo apt install traceroute
fi

cat /etc/issue | grep -q "Debian"
if [[ $? == 0 ]];then
    echo -e "\n\033[1;32m[Info] Debian Update\033[0m";sleep 2s
    sudo apt update
    sudo apt install traceroute
fi

cat /etc/issue | grep -q "Kernel"
if [[ $? == 0 ]];then
    whereis traceroute | grep -q bin
    if [[ $? != 0 ]];then
        echo -e "\n\033[1;32m[Info] CentOS Install traceroute\033[0m";sleep 2s
        yum install traceroute -y
    fi
fi

echo -e "\n该小工具可以为你检查本服务器到中国北京、上海、广州的[回程网络]类型\n"
read -p "按Enter(回车)开始启动检查..." sdad
clear;
iplise=(219.141.136.10 202.106.196.115 211.136.28.231 202.96.199.132 211.95.72.1 211.136.112.50 61.144.56.100 211.95.193.97 120.196.122.69)
iplocal=(北京电信 北京联通 北京移动 上海电信 上海联通 上海移动 广州电信 广州联通 广州移动)
echo -e "\033[0m\033[1;32m[Info] 开始测试，请稍后...\033[0m";sleep 2s
export starttime=`date "+%Y-%m-%d %H:%M:%S"`
echo -e "——————————————————————————————\n"
for i in {0..8}; do
	traceroute ${iplise[i]} | head -n 15 > /root/traceroute_testlog
	grep -q "59.43" /root/traceroute_testlog
	if [ $? == 0 ];then
		grep -q "202.97"  /root/traceroute_testlog
		if [ $? == 0 ];then
			echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;32m电信CN2 GT\033[0m(AS4134)"
		else
			echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;31m电信CN2 GIA\033[0m(AS4809)"
		fi
	else
		grep -q "202.97"  /root/traceroute_testlog
		if [ $? == 0 ];then
			echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;34m电信163\033[0m(AS4134)"
		else
			grep -q "218.105"  /root/traceroute_testlog
			if [ $? == 0 ];then
				echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通A网\033[0m(AS9929)"
			else
				grep -q "223.120"  /root/traceroute_testlog
				if [ $? == 0 ];then
					echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;35m移动CMI\033[0m(AS9808)"
				else
					grep -q "221.183"  /root/traceroute_testlog
					if [ $? == 0 ];then
						echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;35m移动cmi\033[0m(AS9808)"
					else
						grep -q "219.158"  /root/traceroute_testlog
						if [ $? == 0 ];then
							echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:\033[1;33m联通169\033[0m(AS4837)"
						else
							echo -e "目标:${iplocal[i]}[${iplise[i]}]\t回程线路:其他"
						fi
					fi
				fi
			fi
		fi
	fi
echo 
done
export endtime=`date "+%Y-%m-%d %H:%M:%S"`
start_seconds=$(date --date="$starttime" +%s);
end_seconds=$(date --date="$endtime" +%s);
times=$((end_seconds-start_seconds))
rm -rf /root/traceroute_testlog
echo -e "——————————————————————————————\n\033[0m\033[1;32m\n[Info] 测试完成，用时\033[0m $times \033[1;32m秒。结果仅供参考\033[0m\n"
