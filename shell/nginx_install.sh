

#nginx 编译安装

#1 安装最新gcc及nginx所需要依赖


#! /bin/sh
echo "nginx 安装:";
echo "安装所需要依赖: "


sudo yum -y install gcc gcc-c++ autoconf automake
sudo yum -y install zlib zlib-devel openssl openssl-devel pcre-devel

echo "下载并解压 1.13.9 nginx 源代码\n"

cd /usr/local/src

sudo wget http://nginx.org/download/nginx-1.13.9.tar.gz

sudo tar -zxvf nginx-1.13.9.tar.gz -C /usr/local/src

cd /usr/local/src/nginx-1.13.9

echo "解压完成。。。。。。。"


echo " configure 参数：start------------------------------------";

sudo ./configure \
--prefix=/usr/local/nginx \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--user=nginx \
--group=nginx \
--with-stream \
--with-stream_ssl_module \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_stub_status_module \
--with-mail \
--with-mail_ssl_module \
--with-file-aio 

echo  " configure 参数结束------------------------------------------------";

echo 
sudo make && make install 

echo "编译安装结束..... make test.............."

echo "添加logs日志";

sudo mkdir /usr/local/nginx/logs
sudo mkdir /usr/local/nginx/conf/conf.d

sudo vim /usr/local/nginx/conf.d/test.conf

sudo useradd -s /sbin/nologin -M nginx 
sudo id nginx 


sudo /usr/local/nginx/sbin/nginx -t 






