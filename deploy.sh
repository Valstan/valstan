#!/usr/bin/env bash

uTiLiTeS="nano mc build-essential libssl-dev git cron socat curl libcurl3 openssl dirmngr"
apt update
apt upgrade -y

# Утилиты
apt install -y $uTiLiTeS

# NodeJS
curl -sL https://deb.nodesource.com/$NoDeVeRSioN | bash -
apt install -y nodejs

# MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
apt update
apt install -y mongodb-org
service mongod start

# Заливаем и распаковываем Фортуналог через FTP
cd /$5
rm $4.zip
wget ftp://$1:$2@$3/$4.zip
tar -xf $4.zip
rm $4.zip

# PM2
npm install pm2@latest -g

# Устанавливаем модули сервера
cd /$5/$4
npm install
node postinstall.js

# letsencript
cd
wget -O -  https://get.acme.sh | sh

# Запускаем сервер
pm2 startup index.js
pm2 save
