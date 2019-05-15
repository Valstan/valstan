#!/usr/bin/env bash

# Проверяем введены ли аргументы
if (( $# < 3 )); then
echo "!ОШИБКА! Введен мало аргументов! Пример запуска скрипта:"
echo "./deploy ftp://ftplogin:ftpassword@ftpaddress.com/dir zipfile.zip /var/www/webserver"
exit
fi

# Присваиваем переменым значения
NoDeVeRSioN="setup_10.x"
uTiLiTeS="nano mc build-essential libssl-dev cron socat curl libcurl3 openssl dirmngr"

# Утилиты
apt update
apt upgrade -y
apt install -y $uTiLiTeS

# NodeJS
curl -sL https://deb.nodesource.com/$NoDeVeRSioN | bash -
apt install -y nodejs

# MongoDB
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list
apt update
apt install -y mongodb-org
service mongod start

# Создаем путь до вебсервера (ВС), очищаем папку ВС (если она уже была),
# переходим в папку ВС, скачиваем архив с ВС, извлекаем архив, удаляем архив.
mkdir -m u+x -p $3
rm -rf $3/*
cd $3
wget $1/$2
tar -xf $2 --strip-components 1
rm $2

# PM2
npm install pm2@latest -g

# Устанавливаем модули сервера
npm install
node postinstall.js

# letsencript
cd
wget -O -  https://get.acme.sh | sh

# Запускаем сервер
cd $3
pm2 startup index.js
pm2 save
