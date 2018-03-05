#! /bin/sh
#开机启动脚本，脚本代码来自网络，实测有效
#! /bin/sh
# Comments to support chkconfig on CentOS

set -e

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DESC="php-fpm daemon"
NAME=php-fpm
DAEMON=/usr/local/php/sbin/$NAME

CONFIGFILE=/usr/local/php/etc/php-fpm.conf
PIDFILE=/usr/local/php/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

# Gracefully exit if the package has been removed.
test -x $DAEMON || exit 0

d_start() {
  $DAEMON -y $CONFIGFILE || echo -n " already running"
}

d_stop() {
  kill -QUIT `cat $PIDFILE` || echo -n " not running"
}

d_reload() {
  kill -HUP `cat $PIDFILE` || echo -n " can't reload"
}

case "$1" in
  start)
        echo -n "Starting $DESC is success"
        d_start
        echo "."
        ;;
  stop)
        echo -n "Stopping $DESC is success"
        d_stop
        echo "."
        ;;
  reload)
        echo -n "Reloading $DESC configuration..."
        d_reload
        echo "reloaded."
  ;;
  restart)
        echo -n "Restarting $DESC is success"
        d_stop
        sleep 1
        d_start
        echo "."
        ;;
  *)
         echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
         exit 3
        ;;
esac


