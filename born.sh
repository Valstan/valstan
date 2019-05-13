#!/usr/bin/env bash
# Скрипт обновления CRM от Valstan v.0.3

# логируем старт скрипта для отладки
echo `date`>> born.log
echo " script is starting " >> born.log

# Забираем переменные из конфигурационного файла born.cfg
source ./born.config

# Установка утилит и НОДы
if [ $FLAG = 0 ]
    then
        curl -sL https://deb.nodesource.com/setup_10.x | bash -
        apt install -y nodejs build-essential
    else
        echo ""
fi

# Обновление НОДы
if [ $FLAG = 1 ]
    then
        nvm uninstall --lts
        nvm install --lts
        nvm use --lts
    else
        echo ""
fi

# Обновление CRM
if [ $FLAG = 2 ]
    then
        wget -r -np -N -nH --cut-dirs=1 -P ~/crm ftp://id45d_valstan:metro2000@id45d.myjino.ru/crm
    else
        echo ""
fi

# Обновление этого скрипта BORN
#if [ $FLAG = 4 ]
#    then
#        ./born.update
#        exit
#    else
#        echo ""
#fi
# Конец обновления этого скрипта BORN

# Начинаем операцию обновления CRM
# Входим в локальный каталог, куда будем копировать файлы
cd $LOCALDIR
exit


