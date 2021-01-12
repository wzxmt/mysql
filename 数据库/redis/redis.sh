#!/bin/bash
#################################################
#    File Name: redis {start|stop|restart|status}
#       Author: lxw
#         Mail: 1451343603@qq.com
#     Function: 
# Created Time: Thu 29 Nov 2018 09:26:30 PM CST
#################################################

pid=/data/6379/redis.pid
redis_conf=/data/6379/redis.conf

redis(){
	RETVAL=$?
	if [ $RETVAL -eq 0 ];then
		echo "redis $1 successed!"
	else
		echo "redis $1 failsed!"
	fi
}
start_redis(){
	if [ ! -f $pid ];then
		redis-server $redis_conf
	else
		echo "redis is runing!"
		exit
	fi
}
stop_redis(){
	if [ ! -f $pid ];then
		echo "redis is not runing!"
		exit
	else
		kill `cat $pid`
	fi
}
restart_redis(){
	if [ ! -f $pid ];then
		echo "redis is not runing!"
		redis-server $redis_conf
		sleep 2
		redis start
	else
		kill `cat $pid`
		sleep 2
		redis stop
		sleep 2
		redis-server $redis_conf
		redis start
	fi
}
status_redis(){
	if [ ! -f $pid ];then
		echo "redis is not runing!"
	else
		echo "redis is runing!"
	fi
}

case $1 in
	start)
		start_redis
		redis start
		;;
	stop)
		stop_redis
		redis stop
		;;
	restart)
		restart_redis
		;;
	status)
		status_redis
		;;
	*)
		echo $"USAGE: $0 {start|stop|restart|status}" 
esac 
