#!/bin/bash
#变量
set -e
COLOR="echo -e \\E[1;32m"
COLOR1="echo -e \\E[1;31m"
END="\\E[0m"
install_dir="/apps"

#函数
node_exporter_install() {
#判断安装目录是否存在
[ -f ${install_dir} ] || mkdir -p $install_dir
#下载软件
cd $install_dir
wget https://ghproxy.com/https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz &> /dev/null
#解压软件包，并创建软链接
tar xf node_exporter-1.5.0.linux-amd64.tar.gz
ln -sv node_exporter-1.5.0.linux-amd64 node_exporter &> /dev/null
#创建node-exporter的service文件
cat > /usr/lib/systemd/system/node-exporter.service <<EOF
[Unit]
Description=This is prometheus node exporter

[Service]
Type=simple
ExecStart=/apps/node_exporter/node_exporter
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
#同步service文件
systemctl daemon-reload
#启动node-exporter
systemctl start node-exporter.service
#设置node-exporter开机启动
systemctl enable node-exporter.service &> /dev/null
}

node_exporter_install

#变量
node_exporter_port=`ss -ntlp | grep -o 9100`
if [ $node_exporter_port == "9100" ];then
    ${COLOR}node-exporter安装成功!${END}
else
    ${COLOR1}node-exporter安装失败!${END}
fi
