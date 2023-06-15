#!/bin/bash
# Configuration variables
BACKUP_NAME="202306152142"       # folder name in the blob storage
ARCHIVE_NAME="db_backup.dump"    # file name in the blob storage
# Connection string for Azure Blob Storage
CONNECTION_STRING_AZURE="DefaultEndpointsProtocol=https;AccountName=filesmanagermangos;AccountKey=71ms2t3YFnW7Qu4KllgC1PR5adRZVUhbqKGn7mIXaQI0ZgF7ougQUR0LWhf7icECM98YdV9c2grT+ASt8ZXu+g==;EndpointSuffix=core.windows.net"
# Creates the directory
mkdir -p postgresqlrestore/$BACKUP_NAME
# Update and upgrade the packages
apk update
apk upgrade
apk add postgresql-client
# Azure CLI command for enable dynamic install without a prompt.
az config set extension.use_dynamic_install=yes_without_prompt
# Dowlnoad the backup from the blob storage
az storage blob download --container $CONTAINER --name postgresql/$BACKUP_NAME/$ARCHIVE_NAME --file postgresqlrestore/$BACKUP_NAME/$ARCHIVE_NAME --auth-mode key --connection-string $CONNECTION_STRING_AZURE
# Restore a PostgreSQL database from a backup using psql
PGPASSWORD="$POSTGRESQL_PASSWORD" psql --set ON_ERROR_STOP=off -h $DB_HOST -U $POSTGRESQL_USERNAME -f postgresqlrestore/$BACKUP_NAME/$ARCHIVE_NAME 