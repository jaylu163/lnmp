#! /bin/sh

echo "【安装rdkafka是php-rdkafka的依赖】"


cd /usr/local/src

echo "下载librdkafka文件"
sudo wget -O librdkafka.zip https://github.com/edenhill/librdkafka/archive/master.zip

sudo unzip librdkafka.zip

cd librdkafka-master

echo "配置参数及编译安装................"

sudo ./configure  --prefix=/usr/local
sudo make
sudo make install

echo "编译安装完成..........................................................."




echo "【安装php-rdkafka】"

cd /usr/local/src

sudo wget  http://pecl.php.net/get/rdkafka-3.0.5.tgz

sudo tar -zxvf rdkafka-3.0.5.tgz

cd rdkafka-3.0.5 

sudo /usr/local/php/bin/phpize #加载php扩展模块

sudo ./configure  --with-php-config=/usr/local/php/bin/php-config

sudo make 

sudo make install 

echo "安装完成.....手动添加rdkafka.so到php扩展配置php.ini中"


