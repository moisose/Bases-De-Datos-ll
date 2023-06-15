#!/bin/bash

# Variables de configuración
BACKUP_NAME="202306150054"       # Nombre del archivo de respaldo en el Blob Storage
ARCHIVE_NAME="db_backup.dump" #Nombre del contenedor en el Blob Storage
CONNECTION_STRING_AZURE="DefaultEndpointsProtocol=https;AccountName=filesmanagermangos;AccountKey=71ms2t3YFnW7Qu4KllgC1PR5adRZVUhbqKGn7mIXaQI0ZgF7ougQUR0LWhf7icECM98YdV9c2grT+ASt8ZXu+g==;EndpointSuffix=core.windows.net"
DB_NAME = "babynames"

# Crear directorio para almacenar el backup
mkdir -p mariadbrestore/$BACKUP_NAME

# Instalar cliente de MariaDB
apk update
apk upgrade 
apk add mariadb-client

# Descargar el backup desde Azure Blob Storage
echo "Descargando el respaldo desde Azure Blob Storage"
az storage blob download --container $CONTAINER --name mariadb/$BACKUP_NAME/$ARCHIVE_NAME --file mariadbrestore/$BACKUP_NAME/$ARCHIVE_NAME --auth-mode key --connection-string $CONNECTION_STRING_AZURE

# Restaurar el backup en la base de datos
echo "Restaurando el respaldo en MariaDB"
mysql -u $MARIADB_USERNAME -p $MARIADB_PASSWORD $DB_NAME < mariadbrestore/$BACKUP_NAME/$ARCHIVE_NAME