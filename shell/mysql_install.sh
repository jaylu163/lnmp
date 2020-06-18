
###########


echo '安装mysql 相关依赖... start';

yum -y install ncurses ncurses-devel openssl-devel bison gcc gcc-c++ make cmake


echo '安装mysql 依赖完成。。。。。万里长城走出第一步了。加油🐶'😄'';

echo 'mysql 5.7需要安装 boost库... start'

wget https://netix.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
echo '解压boost库....'
tar zxvf boost_1_59_0.tar.gz
echo '解压boost库完成 又开心近了一步';

echo '下载mysql mysql-5.7.22.tar.gz  start ......'
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.22.tar.gz

tar -C /usr/local -zxvf mysql-5.7.22.tar.gz

echo '解压mysql完成。。。。'


echo '生成mysql 编译的脚本 cmake';
