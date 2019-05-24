#!/usr/bin/env bash

[ $# -eq 0 ] && echo "Используйте: $0 arg1 arg2"; exit;

# Проверка на сервере

# Если нет пользователя, то создаем
id -u $1
if [ $? -eq 0 ] then 
apt update
apt upgrade -y
apt install -y sudo
adduser $1
usermod -a -G sudo $1
su - $1
sudo ./$0 $1 $2
exit
fi

# Далее работаем от имени пользователя с правами SUDO
utilites="sudo unzip nano mc build-essential libssl-dev cron socat curl libcurl3 openssl dirmngr"
download="crm.zip"
prefix="temp_"

apt install -y $utilites
# current=$PWD
cd ~
for file in $(echo $download | tr " " "\n")
do
    filename=$file
	    for name in $(echo $file | tr "." "\n")
    	do 
        	filename=$name
        	break
    	done
    wget -O $prefix$file $2/$file
    rm -rf $prefix$filename
    mkdir $prefix$filename
	# tar -xf $prefix$file -C $prefix$filename
    unzip -d $prefix$filename $prefix$file
    cd $prefix$filename
    chmod +x install.sh
    ./install.sh
	# cd $current
    cd ~
done

# очистка
exit