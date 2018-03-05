

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


sudo useradd -s /sbin/nologin -M nginx 
sudo id nginx 



sudo /usr/local/nginx/sbin/nginx -t 





echo "........加入开机自启动.......................................";


path= "./nginx_init.sh"


sudo cp ./nginx_init.sh /etc/init.d/nginx


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


