
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





##########################文本配置##################

groupadd mysql
useradd -r -g mysql -s /bin/false -M mysql

#############将mysql服务文件拷贝到/etc/init.d/目录，并给出执行权限
cp /usr/local/mysql-5.7.22/support-files/mysql.server /etc/init.d/mysqld
chmod a+x /etc/init.d/mysqld
#########开机自启动

chkconfig --add mysqld
chkconfig mysqld on
chkconfig --list | grep mysqld

###########初始化数据库
mysqld_safe --basedir=/usr/local/mysql --datadir=/usr/local/mysql57/data --user=mysql

############赋予目录mysql权限
chown -R mysql:mysql  /var/mysql

##### mysql start 失败执行
chown -R mysql.mysql /var/mysql/data

