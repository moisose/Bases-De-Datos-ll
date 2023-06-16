#!/bin/bash
# Configuration variables
BACKUP_NAME="202306150036"      # folder name in the blob storage
ARCHIVE_NAME="archive.gz"       # file name in the blob storage
# Connection string for Azure Blob Storage
CONNECTION_STRING_AZURE="DefaultEndpointsProtocol=https;AccountName=filesmanagermangos;AccountKey=71ms2t3YFnW7Qu4KllgC1PR5adRZVUhbqKGn7mIXaQI0ZgF7ougQUR0LWhf7icECM98YdV9c2grT+ASt8ZXu+g==;EndpointSuffix=core.windows.net"
# Creates the directory
mkdir -p mongorestore/$BACKUP_NAME
# Update and upgrade the packages
apk update
apk upgrade
# The MongoDB tools provide import, export, and diagnostic capabilities.
apk add  mongodb-tools
# Azure CLI command for enable dynamic install without a prompt.
az config set extension.use_dynamic_install=yes_without_prompt
# Dowlnoad the backup from the blob storage
az storage blob download --container $CONTAINER --name mongo/$BACKUP_NAME/$ARCHIVE_NAME --file mongorestore/$BACKUP_NAME/$ARCHIVE_NAME --auth-mode key --connection-string $CONNECTION_STRING_AZURE
# Restore a PostgreSQL database from a backup using mongo restore
mongorestore --host="$MONGO_CONNECTION_STRING" -u $MONGO_USERNAME -p $MONGO_PASSWORD --gzip --archive=mongorestore/$BACKUP_NAME/$ARCHIVE_NAME