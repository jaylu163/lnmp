#! /bin/sh



echo "【安装msgpack】"


cd /usr/local/src

sudo wget http://pecl.php.net/get/msgpack-2.0.2.tgz;

sudo tar zxvf msgpack-2.0.2.tgz

cd msgpack-2.0.2

sudo /usr/local/php/bin/phpize 

echo "配置参数编译安装完成......................."

sudo ./configure --with-php-config=/usr/local/php/bin/php-config 

sudo make 

sudo make install

echo "【msgpack安装完成.......................请把msgpack.so请加到php.ini文件中.................】"


