#!/bin/sh

tt_server_path=/home/chenqw/TeamTalk/server/im-server-1.0.0

db_proxy_server_dir=$tt_server_path/db_proxy_server
db_proxy_server_name=db_proxy_server

route_server_dir=$tt_server_path/route_server
route_server_name=route_server

file_server_dir=$tt_server_path/file_server
file_server_name=file_server

msfs_server_dir=$tt_server_path/msfs
msfs_server_name=msfs

login_server_dir=$tt_server_path/login_server
login_server_name=login_server

msg_server_dir=$tt_server_path/msg_server
msg_server_name=msg_server

push_server_dir=$tt_server_path/push_server
push_server_name=push_server

http_msg_server_dir=$tt_server_path/http_msg_server
http_msg_server_name=http_msg_server

function tt_status_echo()
{
    server_name=$1
    status=$2
    #echo -e "[\033[0;31m$server_name\033[0m] status:          [\033[1;32m$status\033[0m]"
    printf "\033[0;31m%-15s\033[0m status:            \033[1;32m%-15s\033[0m\n" $server_name $status
}

function tt_start_echo()
{
    server_name=$1
    result=$2
    #echo -e "Starting [\033[0;31m$server_name\033[0m]:            [\033[1;32m$result\033[0m]"
    printf "Starting \033[0;31m%-15s\033[0m:            \033[1;32m%-15s\033[0m\n" $server_name $result
}

function tt_stop_echo()
{
    server_name=$1
    result=$2
    #echo -e "Stopping [\033[0;31m$server_name\033[0m]:            [\033[1;32m$result\033[0m]"
    printf "Stopping \033[0;31m%15s\033[0m:            \033[1;32m%-15s\033[0m\n" $server_name $result
}

function tt_server_start()
{
    server_dir=$1
    server_name=$2

    if ps -C $server_name > /dev/null 2>&1 ; then
        tt_status_echo $server_name IS_RUNNING
    else
	cd $server_dir
    	if `./daeml $server_dir/$server_name` > /dev/null 2>&1 ; then
            tt_start_echo $server_name OK
    	else
            tt_start_echo $server_name FAILED
            exit 1
        fi
	cd .
    fi
}

function tt_server_stop()
{
    server_name=$1

    if ps -C $server_name > /dev/null 2>&1 ; then
        if /usr/bin/killall $server_name  > /dev/null 2>&1 ; then
            tt_stop_echo $server_name OK
        else
            tt_stop_echo FAILED
    	    exit 1
        fi
    else
        tt_status_echo $server_name NOT_RUNNING
    fi  
}

function tt_server_status()
{
    server_name=$1
    if ps -C $server_name > /dev/null 2>&1 ; then
        tt_status_echo $server_name RUNNING
    else
        tt_status_echo $server_name STOPPED
    fi
}

case "$1" in
    start)
	tt_server_start $db_proxy_server_dir $db_proxy_server_name
	tt_server_start $route_server_dir $route_server_name
	tt_server_start $file_server_dir $file_server_name
	tt_server_start $msfs_server_dir $msfs_server_name
        tt_server_start $login_server_dir $login_server_name
	tt_server_start $msg_server_dir $msg_server_name
	tt_server_start $push_server_dir $push_server_name
	tt_server_start $http_msg_server_dir $http_msg_server_name
        ;;
    status)
        tt_server_status $db_proxy_server_name
        tt_server_status $route_server_name
        tt_server_status $file_server_name
        tt_server_status $msfs_server_name
        tt_server_status $login_server_name
        tt_server_status $msg_server_name
        tt_server_status $push_server_name
        tt_server_status $http_msg_server_name
        ;;
    stop)
        tt_server_stop $db_proxy_server_name
        tt_server_stop $route_server_name
        tt_server_stop $file_server_name
        tt_server_stop $msfs_server_name
        tt_server_stop $login_server_name
        tt_server_stop $msg_server_name
        tt_server_stop $push_server_name
        tt_server_stop $http_msg_server_name
	;;
    *)
	echo "Usage: `basename $0` (start|stop|status)"
	;;
esac
