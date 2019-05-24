#!/usr/bin/env bash

[ $# -eq 0 ] && echo "Используйте: $0 argument"; exit;


cd ~
utilites="unzip nano mc build-essential libssl-dev cron socat curl libcurl3 openssl dirmngr"
download="crm.zip"
prefix="temp_"

apt update
apt upgrade -y
apt install -y $utilites
# current=$PWD

for file in $(echo $download | tr " " "\n")
do
    filename=$file
    for name in $(echo $file | tr "." "\n")
    do 
        filename=$name
        break
    done
    echo $file
    wget -O $prefix$file $1/$file
    rm -rf $prefix$filename
    mkdir $prefix$filename
# tar -xf $prefix$file -C $prefix$filename
    unzip -d $prefix$filename $prefix$file
    cd $prefix$filename
    chmod +x install.sh
    ./install.sh
#   cd $current
    cd ~
done

# очистка
exit