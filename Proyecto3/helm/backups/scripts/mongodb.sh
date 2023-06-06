#!/bin/bash
# get the current date and time
DATE=$(date '+%Y%m%d%H%M')
# create a directory with the current date
# the [-p] arg is used bs /mongodump may not exist
mkdir -p /mongodump/$DATE
apk update
apk upgrade
# The MongoDB tools provide import, export, and diagnostic capabilities.
apk add  mongodb-tools
# Azure CLI command for enable dynamic install without a prompt.
az config set extension.use_dynamic_install=yes_without_prompt
# mongodump configuration for connect to an instance
# --host, -u or --username, -p or --password, --gzip(compress the output), --archive(Writes the output to a specified archive file)
mongodump --host="$MONGO_CONNECTION_STRING" -u $MONGO_USERNAME -p $MONGO_PASSWORD --gzip --archive=/mongodump/$DATE
az storage blob directory upload --container $CONTAINER -s /mongodump/$DATE -d $BACKUP_PATH --auth-mode key --recursive
rm -rf /mongodump/$DATE