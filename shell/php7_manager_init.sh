sudo chmod a+x /etc/init.d/php-fpm

sudo chkconfig php-fpm on

sudo chkconfig --list

echo "#php-fpm启动服务"

sudo service php-fpm start 



ehco "#重启服务.............."

sudo service php-fpm reload


echo "#停止服务......"

sudo service php-fpm stop

echo "#php-fpm启动服务"

sudo service php-fpm start 


