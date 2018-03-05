#! /bin/sh

echo "........加入开机自启动.......................................";


path= "./nginx_init.sh"


sudo cp /home/luhuajun/nginx_init.sh /etc/init.d/nginx


sudo chmod a+x /etc/init.d/nginx

echo "测试开起nginx ....start";

sudo /etc/init.d/nginx start


echo "测试关闭nginx....stop";

sudo /etc/init.d/nginx stop


echo "........nginx服务加入chkconfig管理列表......................";

sudo chkconfig --add /etc/init.d/nginx


echo "service nginx 管理----------------------";


echo "测试 service nginx start...................."


sudo service nginx start

echo "测试 service nginx stop...............................";


sudo service nginx stop;


echo "设置终端模式开机启动--------------------------------";


sudo  chkconfig nginx on
