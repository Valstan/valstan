#!/usr/bin/env bash
    apt update
    apt upgrade -y
# Ставим утилиты для себя и для Ноды
    apt install -y nano mc build-essential libssl-dev curl

# Ставим NVM
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
    export NVM_DIR="${XDG_CONFIG_HOME/:-$HOME/.}nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Ставим Ноду
    nvm install --lts
    nvm use

# Ставим PM2
    npm install pm2@4.17.4 -g
    
# Ставим МОНГО
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
    echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list
    apt update
    apt install -y mongodb-org

# Заливаем и распаковываем Фортуналог
    wget -P /home/ ftp://id45d_valstan:metro2000@id45d.myjino.ru/crm.zip
    cd /home
    tar -xf crm.zip

# Устанавливаем модули сервера
    npm install /home/crm/modulinstall.sh

# Запускаем сервер
    pm2 start /home/crm/index.js
    sleep 20s
    pm2 stop # я не понял пока нужны ли тут аргументы, нужно остановить вебсервер

# скрипт автоматической настройки сертификата letsencript (еще не пробовал, возможно тут чтото надо будет вводить руками ответы на вопросы, если что есть ниже вариант автоматический)
    wget -O -  https://get.acme.sh | sh

# ручная установка letsencript
#    apt install -y certbot -t stretch-backports
#    certbot certonly
#    Остановить веб-сервер
#    далее замени example    
#    certbot certonly --webroot -w /var/www/example -d example.com -d www.example.com -w /var/www/thing -d thing.is -d m.thing.is
#    запусти вебсервер

#    curl -sL https://deb.nodesource.com/setup_10.x | bash -
#    apt update -y
#    apt install -y nodejs
