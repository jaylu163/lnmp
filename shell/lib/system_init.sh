#!/bin/bash
# 用来初始化操作系统

# 关闭 SELinux
function fnCloseSELinux()
{
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
    fnSuccess "\nHas been successfully disabled SELinux"
    getenforce
}

# 禁用 IPv6
function fnDisableIPv6()
{
    if [[ "${disableIPv6}" == "true" || "${disableIPv6}" == "1" ]]; then
        case ${version} in
            "el7" )
                    # 直接禁用 IPv6模块
                    sed -i 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="ipv6.disable=1 /g' /etc/default/grub
                    # 重新生成引导文件
                    fnLog "Disable IPv6"
                    grub2-mkconfig -o /boot/grub2/grub.cfg >> ${logFile} 2>&1

                    
                    fnSuccess "Has been successfully disabled IPv6"
                    ;;
                * )
                    fnWarning "Can not disable IPv6,Because current OS not supper"
                    ;;
        esac

        fnSuccess "\nAlready disable IPv6,but it's require reboot system"
    else
        fnWarning "Can not disable IPv6,Because config is flase"
    fi
}


# 配置主机名
function fnHostname()
{
    # 配置主机名
    hostname $myHost
    echo "$myHost" > /etc/hostname
    # 修改 本地 hosts
    echo -e "127.0.0.1 localhost $myHost" > /etc/hosts
    fnSuccess "\nThe host name has been configured as $myHost"
}

# 配置 ulimit
function fnUlimit()
{
    if ! grep "* soft nproc ${ulimitNumber}" /etc/security/limits.conf > /dev/null; then
        echo -e "\n\n* soft nproc ${ulimitNumber}\n\
        * hard nproc ${ulimitNumber}\n\
        * soft nofile ${ulimitNumber}\n\
        * hard nofile ${ulimitNumber}\n" >> /etc/security/limits.conf
        fnSuccess "\nHas been successfully config ulimt is : ${ulimitNumber}"
    else
        fnSuccess "\nThe ulimit has been  ${ulimitNumber},can not config"
    fi

}

# 更新系统
function fnUpdate()
{
    if [[ "${isUpdate}" == "true" ]]; then
        echo -e "\nSystem update may take a long time, please wati ."
        echo -e "Operating system updating . . . . ."
        fnLog "Has been update os"
        
        
        yum -y update >> ${logFile} 2>&1

        fnSuccess "Has been successfully update oprating"
    fi
}

# 安装需要的软件包
function fnInstallPackage()
{
    echo -e "\nInstall Package may take a long time, please wati ."
    echo -e "Package installing . . . . . ."
    fnLog "Install package"
    yum install -y ${package} >> ${logFile} 2>&1
    fnSuccess "Has been installed ${package}"
}

# 禁用 Firewalld，启用 iptables
function fnIptables()
{
    fnLog "Staring config firewall"
    systemctl stop firewalld >>  ${logFile} 2>&1
    systemctl disable firewalld >>  ${logFile} 2>&1
    yum remove -y firewalld >> ${logFile} 2>&1
    yum install -y iptables-services >> ${logFile} 2>&1
    systemctl enable iptables
    systemctl start iptables

    fnSuccess "\nHas been remove firewalld and install iptables"
}

# 配置 sshd
function fnSshd()
{
    # 配置文件中配置了 ssh 端口才会去配置
    if [[ -n "$sshPort" ]]; then
        # 修改端口号
        sed -i 's/^\(#Port\|Port\).*$/Port '${sshPort}'/g' /etc/ssh/sshd_config   
        # 配置防火墙
        sed -i 's/--dport '${sshOldPort}' -j/--dport '${sshPort}' -j/g' /etc/sysconfig/iptables


        echo $?---------------------------------------------------

        # 防止防火墙再次配置不生效，配置成功之后自动更新旧的端口
        sed -i 's/^sshOldPort=.*$/sshOldPort='${sshPort}'/g' ${baseDir}/config

        fnSuccess "\nHas been update sshd port,Please make sure the firewall is open ${sshPort}"
    fi
}

function fnVimrc()
{
    filePath="/home/${loginUser}/.vimrc"
    echo -e "\n:set nu\n:set tabstop=4\n:set expandtab\n\
:set autoindent\n:set shiftwidth=4\n:set smartindent" > ${filePath}

    chown -R ${loginUser}:${loginUser} ${filePath}

    fnSuccess "\nHas been configure ${filePath}"
}

# 禁用用不到的系统服务器
function fnDisableServer()
{
    # 暂时只禁用一个 postfix 服务器
    systemctl disable postfix
    systemctl stop postfix
}

function fnSystemInit()
{
    fnCloseSELinux
    fnDisableIPv6
    fnHostname
    fnUlimit
    fnUpdate
    fnInstallPackage
    fnIptables
    fnSshd
    fnVimrc
    fnDisableServer

    fnWarning "\nWarning: System initialization is complete, some functions need to take effect after the restart"
    while [[ "$yn" != "yes" ]]
    do
        read -p "Please input [ yes | no ]: " yn
        case "$yn" in
            "yes" | "y" )
                echo -e "\nThe system will restart after 10 seconds, if you do not want to reboot, please enter \"Ctrl+C\""
                sleep 10
                reboot
                exit 1
                ;;
             "no" | "n" )
                return
                ;;
              *)
                fnError "\nInvalid parameter"
                ;;
        esac
    done
}

# 检测是否使用此脚本初始化过系统
function checkLock()
{
    if [ -z "${isInit}" ]; then
        if [ ! -f ${baseDir}/lock/system_init.lock ]; then
            fnWarning "\nYou have never used this script to initialize the system, may I need to run the initialization script?"
        else
            fnWarning "\nYou have already used this script to initialize the system, will you need to run the initialization script?"
        fi
    fi
    read -p "Please input [ yes | no ]: " isInit

    case ${isInit} in
        "yes" | "y" )
            fnSuccess "Staring init System."
            fnSystemInit
            echo $(date +%Y-%m-%d' '%H:%M:%S) > ${baseDir}/lock/system_init.lock
            ;;
         "no" | "n" )
            fnWarning "Please make sure you have done the initial configuration, for example: SELinux has been closed!"
            ;;
         * )
            fnError "\nInvalid parameter input !!"
            checkLock
            ;;
    esac
}


[ -z "${isInit}" ] && checkLock

