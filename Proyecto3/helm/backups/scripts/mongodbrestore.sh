#!/bin/bash

# Variables de configuración
BACKUP_NAME="202306150036"       # Nombre del archivo de respaldo en el Blob Storage    # Nombre del contenedor en el Blob Storage
ARCHIVE_NAME="archive.gz"       # Nombre del archivo de respaldo en el Blob Storage
CONNECTION_STRING_AZURE="DefaultEndpointsProtocol=https;AccountName=filesmanagermangos;AccountKey=71ms2t3YFnW7Qu4KllgC1PR5adRZVUhbqKGn7mIXaQI0ZgF7ougQUR0LWhf7icECM98YdV9c2grT+ASt8ZXu+g==;EndpointSuffix=core.windows.net"

mkdir -p mongorestore/$BACKUP_NAME
apk update
apk upgrade
# The MongoDB tools provide import, export, and diagnostic capabilities.
apk add  mongodb-tools

# Azure CLI command for enable dynamic install without a prompt.
az config set extension.use_dynamic_install=yes_without_prompt

echo "Descargando el respaldo desde Azure Blob Storage"
# Descargar el respaldo desde Azure Blob Storage
az storage blob download --container $CONTAINER --name mongo/$BACKUP_NAME/$ARCHIVE_NAME --file mongorestore/$BACKUP_NAME/$ARCHIVE_NAME --auth-mode key --connection-string $CONNECTION_STRING_AZURE

echo "Restaurando el respaldo en MongoDB"
# Restaurar el respaldo en MongoDB
mongorestore --host="$MONGO_CONNECTION_STRING" -u $MONGO_USERNAME -p $MONGO_PASSWORD --gzip --archive=mongorestore/$BACKUP_NAME/$ARCHIVE_NAME

#--host $MONGO_HOST --port $MONGO_PORT --gzip --archive=$BACKUP_PATH/$BACKUP_NAME
