#!/bin/bash
# get the current date and time
DATE=$(date '+%Y%m%d%H%M')
# create a directory with the current date
# the [-p] arg is used bs /mongodump may not exist
mkdir -p /mariadb_dump/$DATE

# to run as root
apk update
apk upgrade 
# Install the mariadb client
apk add mariadb-client
# Azure CLI command for enable dynamic install without a prompt.
az config set extension.use_dynamic_install=yes_without_prompt
# Dump the database
mysqldump --host=$DB_HOST --user=$MARIADB_USERNAME --password=$MARIADB_PASSWORD --result-file > /mariadb_dump/$DATE/db_backup.dump
az storage blob directory upload --container $CONTAINER -s /mariadb_dump/$DATE -d $BACKUP_PATH --auth-mode key --recursive
rm -rf /mariadb_dump/$DATE
echo "Respaldo completado exitosamente"