#! /bin/sh

echo "【安装phpredis】" 

"下载最新的稳定版本redis"

cd /usr/local/src

sudo wget  https://github.com/phpredis/phpredis/archive/master.zip

sudo unzip master.zip

cd phpredis-master;



sudo /usr/local/php/bin/phpize 

sudo ./configure --with-php-config=/usr/local/php/bin/php-config


echo "安装phpredis扩展........................................................."

sudo make && make install

echo "【安装phpredis】.......................................请把对应的redis.so扩展添加到对应的php.ini文件中"
