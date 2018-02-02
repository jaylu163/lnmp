#!/bin/bash
#

baseDir=$(pwd)

# 检测文件是否存在函数
function fnExistFile()
{
    if [ -n "${1}" ]; then
        if [ ! -f "${1}" ]; then
            echo -e "\n\033[31;1mError: Count't found \"${1}\" , please check your file exist.\033[0m\n"
            exit 1
        fi
    fi
}

# 检查是否缺少文件
for file in $(cat ${baseDir}/path|grep -v "^#")
do
    fnExistFile "${baseDir}/${file}"
done

# 引入配置文件
. ${baseDir}/config

# 引入函数
. ${baseDir}/func

# 判断是否有 root 权限
if [[ $UID -ne "0" ]]; then
    fnEchoColor "Please use \"root\" privileges to execute this script" red
    exit 1
fi

clear
fnEchoColor "\n########## Starting config OS . ##########" black bwhite


# 初始化系统
if [[ "$systemVersion" == "CentOS7" ]]; then
    . ${baseDir}/lib/system_init.sh
else
    fnWarning "Can not support your system, there is no automatic initialization"
fi

clear
fnEchoColor "########## Starting install LNMP #########" black bwhite

# 开始安装 LNMP 环境
. ${baseDir}/lib/lnmp.sh
