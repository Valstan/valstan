#!/usr/bin/env bash
source ./valstan.cfg
apt update
apt upgrade -y

# Утилиты
apt install -y $utilites

# NodeJS
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt install -y nodejs

# MongoDB
https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian92-4.0.9.tgz
tar -zxvf mongodb-linux-x86_64-debian92-4.0.9.tgz
apt install -y mongodb-org

# Заливаем и распаковываем Фортуналог через FTP
cd /$webserver
wget ftp://$1:$2@$3/$4.zip
tar -xf $4.zip

# PM2
npm install pm2@latest -g

# Устанавливаем модули сервера
cd /$websever/$4
npm install
node postinstall.js

# letsencript
wget -O -  https://get.acme.sh | sh

# Запускаем сервер
pm2 startup index.js
pm2 save
