#!/bin/bash
DATE=$(date '+%Y%m%d%H%M')
mkdir -p /mongodump/$DATE
apk update
apk upgrade
apk add  mongodb-tools
az config set extension.use_dynamic_install=yes_without_prompt
mongodump --host="$MONGO_CONNECTION_STRING" -u $MONGO_USERNAME -p $MONGO_PASSWORD --gzip --archive=/mongodump/$DATE
az storage blob directory upload --container $CONTAINER -s /mongodump/$DATE -d $BACKUP_PATH --auth-mode key --recursive
rm -rf /mongodump/$DATE