#! /bin/sh


echo "php7.2.3 编译安装----------------------";


echo "php准备依赖-------------------";

sudo yum -y install openssl
sudo yum -y install openssl-devel
sudo yum -y install curl
sudo yum -y install curl-devel
sudo yum -y install libxml2
sudo yum -y install libxml2-devel
sudo yum -y install libjpeg
sudo yum -y install libjpeg-devel
sudo yum -y install libpng
sudo yum -y install libpng-devel
sudo yum -y install freetype
sudo yum -y install freetype-devel
sudo yum -y install pcre
sudo yum -y install pcre-devel
sudo yum -y install libxslt
sudo yum -y install libxslt-devel
sudo yum -y install bzip2
sudo yum -y install bzip2-devel


echo "php依赖安装完成----------------------------------";


cd /usr/local/src;

sudo wget -c  -O php-7.2.3.tar.gz  http://cn2.php.net/get/php-7.2.3.tar.gz/from/this/mirror

sudo tar -zxvf php-7.2.3.tar.gz;

cd php-7.2.3;



echo "php 准备安装参数-------------------------------";


sudo ./configure --prefix=/usr/local/php --with-curl --with-freetype-dir --with-gd --with-gettext --with-iconv-dir --with-kerberos --with-libdir=lib64 --with-libxml-dir --with-mysqli --with-openssl --with-pcre-regex --with-pdo-mysql --with-pdo-sqlite --with-pear --with-png-dir --with-jpeg-dir --with-xmlrpc --with-xsl --with-zlib --with-bz2 --with-mhash --enable-fpm --enable-bcmath --enable-libxml --enable-inline-optimization  --enable-mbregex --enable-mbstring --enable-opcache --enable-pcntl --enable-shmop --enable-soap --enable-sockets --enable-sysvsem --enable-sysvshm --enable-xml --enable-zip


echo "php 准备安装参数结束............................................";



echo "php编译并安装"


sudo make && make install



echo "php.ini,php-fpm.conf配置生成----------------------"


echo "复制php.ini文件到 --prefix目录下的lib下面.............."

sudo cp php.ini-development /usr/local/php/lib/php.ini

echo "复制php-fpm.conf文件到 --prefix目录下面的etc目录下面";


sudo cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf

sudo cp /usr/local/php/etc/php-fpm.d/www.conf.default  /usr/local/php/etc/php-fpm.d/www.conf


echo "把php-fpm放到环境变量中..........................."

sudo cp sapi/fpm/php-fpm /usr/local/bin


echo "php7安装后测试-----------------"


echo "开启pid ,去掉分号注释# pid = run/php-fpm.pid......................................................";

sudo groupadd www
sudo useradd www -g www -s /sbin/nologin -M

exit;
