#!/bin/bash
# 获取安装包

export packages="${baseDir}/packages"
[ -d ${packages} ] || mkdir -p ${packages}

function fnDependentUbuntu1710()
{
    fnSuccess "Ubuntu 17.10"
    apt install -y ${apt} >> ${logFile} 2>&1
}

function fnDependentFedora27()
{
    fnSuccess "Fedora 27"
    dnf install -y ${yum} >> ${logFile} 2>&1
}

function fnDependentCentOS7()
{
    fnSuccess "CentOS 7"
    yum install -y ${yum} >> ${logFile} 2>&1
}

function fnDependent()
{
    # 安装依赖关系
    fnSuccess "Starting install dependent,may be some time,please waiting ....."
    fnLog "Starting install dependent ."
    case $systemVersion in
    CentOS7 )
        fnDependentCentOS7
        ;;
    Ubuntu17.10 )
        fnDependentUbuntu1710
        ;;
    Fedora27 )
        fnDependentFedora27
        ;;
    * )
        fnError "Can not support your system,Script exit"
        exit
        ;;
    esac

}

function fnDownload()
{
    if [ -n ${1} ]; then
        eval source="$"${1}"_version.tar.gz"

        # 下载软件
        if [ ! -f "${packages}/${source}" ]; then
            fnSuccess "\nStarting Download ${source}\n"
            eval url="$"${1}"_url"
            wget $url -P ${packages}/
        fi

        # 解压缩软件
        fnSuccess "\nStarting unzip ${source} . . . . . ."
        tar xzf ${packages}/${source} -C ${src_dir}
    fi
}

function fnMySQLCMake()
{
    mkdir -p ${dir}/build
    cd ${dir}/build
    fnSuccess "\nStaring cmake MySQL,may be some time,please wait ..."
    fnLog "Starting cmake MySQL."
    cmake .. ${mysql_compile} >> ${logFile} 
}

function fnConfigure()
{
    eval compile="$"${1}"_compile" 
    fnSuccess "\nConfigure ${1} Makefile ,may be some time,please wait ..."
    fnLog "Staring compile ${1}"
    ./configure ${compile} >> ${logFile}
}

function fnConfigSystem()
{
    case ${1} in
        "mysql" | "MySQL" | "Mysql" | "MYSQL" )
            process=mysqld
            ;;
        "php" | "PHP" | "Php" | "php-fpm" )
            process=php-fpm
            ;;
        "nginx" | "Nginx" | "NGINX" )
            process=nginx
            ;;
        * )
            process=""
            ;;
    esac

    systemctl daemon-reload

    if [ -n ${process} ]; then
        if netstat -tnlp | grep -i ${process} > /dev/null; then
            systemctl restart ${process}
        else
            systemctl start ${process}
        fi
        systemctl enable ${process}
    fi
}

function fnConfigMySQL()
{
    fnSuccess "\nStarting config MySQL,please wait ..."
    # 添加环境变量
    echo -e "export MYSQL_PATH=${desc_dir}/mysql\nexport PATH=\$PATH:\$MYSQL_PATH/bin" > /etc/profile.d/mysql.sh

    # 设置配置文件
    [ -d ${mysql_config_dir} ] || mkdir -p ${mysql_config_dir}
    echo -e "[mysqld]\nbasedir=${desc_dir}mysql\ndatadir=${mysql_data_dir}data\nsocket=${mysql_sock}\n\
character_set_filesystem=${mysql_charset}\ncharacter_set_server=${mysql_charset}\nsymbolic-links=0\n\
log-error=${mysql_data_dir}log/mysqld_error.log\npid-file=${mysql_data_dir}run/mysqld.pid" > ${mysql_config_dir}/my.cnf

    # 创建数据目录
    mkdir -p ${mysql_data_dir}/{data,log,run}
    # 创建和分配 myql 用户权限
    grep "^${mysql_user}" /etc/passwd > /dev/null || useradd -M -r -s /sbin/nologin ${mysql_user}
    chown -R ${mysql_user}:${mysql_user} ${mysql_data_dir}

    # 初始化数据库
    [ -d ${mysql_data_dir} ] && rm -rf ${mysql_data_dir}/data/* ${mysql_data_dir}/log/*
    ${desc_dir}/mysql/bin/mysqld --defaults-file=${desc_dir}/mysql/etc/my.cnf --initialize --user=${mysql_user}

    # 配置启动脚本
    
    
    cp -rf ${baseDir}/script/mysqld.service /lib/systemd/system/
    # 修改启动脚本
    sed -i 's:/var/run/mysqld/mysqld.pid:'${mysql_data_dir}'/run/mysqld.pid:g' /lib/systemd/system/mysqld.service

    # 启动服务
    fnConfigSystem mysql

    # 配置 MySQL 默认密码
    pass=$(grep -i 'root@localhost' ${mysql_data_dir}/log/mysqld_error.log | tail -n 1 | awk -F: '{print $NF}' |  sed 's/ //g') 
    ${desc_dir}/mysql/bin/mysqladmin -uroot -p${pass} password ${mysql_password}


    fnSuccess "\nHas been config MySQL. Default password is \"${mysql_password}\""
    netstat -tnlp | grep 3306
}

# 配置 PHP
function fnConfigPHP()
{
    fnSuccess "\nStarting config PHP,please wait ..."
    # 创建 PHP 用户
    grep "^${php_user}" /etc/passwd > /dev/null || useradd -M -r -s /sbin/nologin ${php_user}

    # 复制配置文件
    cp -rf ${dir}/php.ini-production ${desc_dir}/php/etc/php.ini
    cp -rf ${dir}/sapi/fpm/php-fpm.service /lib/systemd/system/
    cp -rf ${desc_dir}/php/etc/php-fpm.conf.default ${desc_dir}/php/etc/php-fpm.conf
    cp -rf ${desc_dir}/php/etc/php-fpm.d/www.conf.default ${desc_dir}/php/etc/php-fpm.d/www.conf

    # 修改默认配置文件
    sed -i 's/;date.timezone = /date.timezone = PRC/g' ${desc_dir}/php/etc/php.ini

    # 配置环境变量
    echo -e "export PHP_PATH=${desc_dir}/php\nexport PATH=\$PATH:\$PHP_PATH/bin" > /etc/profile.d/php.sh

    # 配置开机自动启动
    fnConfigSystem php
    fnSuccess "\nHas been config PHP."
    netstat -tnlp | grep -i php
}

# 配置 Nginx
function fnConfigNginx()
{
    fnSuccess "\nStarting config Nginx,please wait ..."

    # 创建 Nginx 用户
    grep "^${nginx_user}" /etc/passwd > /dev/null || useradd -M -r -s /sbin/nologin ${nginx_user}

    # 复制配置文件
    mv ${desc_dir}/nginx/conf/nginx.conf ${desc_dir}/nginx/conf/nginx.conf_`date +%Y-%m-%d`_bak
    cp -rf ${baseDir}/script/nginx.conf ${desc_dir}/nginx/conf/
    sed -i 's/^user.*$/user '${nginx_user}';/' ${desc_dir}/nginx/conf/nginx.conf
    [ -d ${desc_dir}/nginx/conf/conf.d ] || mkdir -p ${desc_dir}/nginx/conf/conf.d
    cp -rf ${baseDir}/script/http.main ${desc_dir}/nginx/conf/conf.d/
    cp -rf ${baseDir}/script/vhost.conf ${desc_dir}/nginx/conf/conf.d/

    # 配置启动脚本
    cp -rf ${baseDir}/script/nginx.service /lib/systemd/system/

    fnConfigSystem nginx
    netstat -tnlp | grep '80'
}

# 安装后的配置
function fnInstallConfig()
{
    
    case ${1} in
        "mysql" )
            fnConfigMySQL
            ;;
        "php" )
            fnConfigPHP
            ;;
        "nginx" )
            fnConfigNginx
            ;;
        * )
            ;;
    esac

}

function fnInstall()
{
    # 执行编译及配置
    for i in mysql php nginx
    do
        # 下载和解压缩
        fnDownload ${i}
    
        ## 进入到目录
        eval dir="${src_dir}$"${i}"_version"
        export dir=$(echo ${dir} | sed 's/-boost//g')
        cd ${dir}
        
        if [[ "$i" == "mysql" ]]; then
            fnMySQLCMake "$i"
            fnSuccess "\nStaring make MySQL,Time will be long,please waiting ..."
            fnLog "Staring compile Mysql"
            make >> ${logFile} 
            make install >> ${logFile}
        else
            fnConfigure "$i"
            fnSuccess "\nStarting make ${i},may be some time,please waiting ..."
            fnLog "Starting compile ${i}"
            make -j ${makeJ} >> ${logFile}
            make install >> ${logFile}
        fi
        fnInstallConfig ${i}
    done
}

fnDependent
fnInstall
