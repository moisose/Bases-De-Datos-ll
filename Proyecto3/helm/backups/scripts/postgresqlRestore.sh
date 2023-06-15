#!/bin/bash

# Variables de configuración
BACKUP_NAME="202306151558"       # Nombre del archivo de respaldo en el Blob Storage    # Nombre del contenedor en el Blob Storage
ARCHIVE_NAME="db_backup.dump"       # Nombre del archivo de respaldo en el Blob Storage
CONNECTION_STRING_AZURE="DefaultEndpointsProtocol=https;AccountName=filesmanagermangos;AccountKey=71ms2t3YFnW7Qu4KllgC1PR5adRZVUhbqKGn7mIXaQI0ZgF7ougQUR0LWhf7icECM98YdV9c2grT+ASt8ZXu+g==;EndpointSuffix=core.windows.net"

mkdir -p postgresqlrestore/202306151558

apk update
apk upgrade
apk add postgresql-client

az config set extension.use_dynamic_install=yes_without_prompt

# Descargar el respaldo desde Azure Blob Storage
az storage blob download --container $CONTAINER --name postgresql/$BACKUP_NAME/$ARCHIVE_NAME --file postgresqlrestore/$BACKUP_NAME/$ARCHIVE_NAME --auth-mode key --connection-string $CONNECTION_STRING_AZURE

# Restore a PostgreSQL database from a backup
PGPASSWORD="$POSTGRESQL_PASSWORD" pg_restore --host $DB_HOST -U $POSTGRESQL_USERNAME -d babynames --clean --if-exists postgresqlrestore/$BACKUP_NAME/$ARCHIVE_NAME