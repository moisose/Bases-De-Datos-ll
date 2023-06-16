#!/bin/bash

# Config Variables
BACKUP_NAME="202306150036"       # Date of backup (folder) in Azure Blob Storage
ARCHIVE_NAME="archive.gz"       # Name of file in Azure Blob Storage
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

# Download backup from Azure Blob Storage
az storage blob download --container $CONTAINER --name mongo/$BACKUP_NAME/$ARCHIVE_NAME --file mongorestore/$BACKUP_NAME/$ARCHIVE_NAME --auth-mode key --connection-string $CONNECTION_STRING_AZURE

# Restore backup to MongoDB
mongorestore --host="$MONGO_CONNECTION_STRING" -u $MONGO_USERNAME -p $MONGO_PASSWORD --gzip --archive=mongorestore/$BACKUP_NAME/$ARCHIVE_NAME

