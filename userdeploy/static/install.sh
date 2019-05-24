#!/usr/bin/env bash

domain="fcrm.kenlit.ru"
folder="/var/www"
node_setup="10"
mongo_setup="4.0"
node_version=$(node -v)
mongo_version=$(mongo --version)

# NODE
if [[ "$node_version" != v* ]]
    then
        curl -sL https://deb.nodesource.com/setup_$node_setup.x | bash -
        apt install -y nodejs
    else
        for part in $(echo $node_version | tr "." "\n")
        do 
            if [[ "$part" != "v$node_setup" ]]
                then
                curl -sL https://deb.nodesource.com/setup_$node_setup.x | bash -
                apt install -y nodejs
            fi
            break
        done
fi

# MongoDB
echo $mongo_version
if [[ "$mongo_version" != M* ]]
    then
        apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
        echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/$mongo_setup main" | tee /etc/apt/sources.list.d/mongodb-org-$mongo_setup.list
        apt update
        apt install -y mongodb-org
fi

# PM2
npm install pm2@latest -g

# letsenscript
wget -O -  https://get.acme.sh | sh

# Копируем вебсервер
mkdir -p $folder/$domain
rm -rf $folder/$domain/*
cp -R ./* $folder/$domain
rm $folder/$domain/install.sh

pm2 stop all
pm2 delete all
cd $folder/$domain
npm install
chmod +x index.js temp.js ./install/index.js
pm2 start temp.js

# Получаем сертификат SSL
/root/.acme.sh/acme.sh --issue -d $domain -d www.$domain -w $folder/$domain/public_html

# Проверяем наличие сертификата
# if [ ! -f ~/.acme.sh/$domain/$domain.cer ] then echo "Cert NO" exit fi
[ ! -f ~/.acme.sh/$domain/$domain.cer ] && echo "Cert NO" exit || echo "Cert OK"

pm2 stop all
pm2 delete all

# service mongod start

# node ./install/index.js

# применяем патчи
cp -R -f $folder/$domain/pacthes/* $folder/$domain/node_modules/

pm2 start index.js
pm2 save

echo "Установка завершена"
exit

# Создать ли cron для проверки отзыва сертификата?