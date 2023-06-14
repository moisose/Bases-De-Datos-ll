#!/bin/bash

# Variables de configuración
BACKUP_NAME="nombre_del_respaldo"       # Nombre del archivo de respaldo en el Blob Storage    # Nombre del contenedor en el Blob Storage

# Descargar el respaldo desde Azure Blob Storage
az storage blob download --container $CONTAINER --name $BACKUP_NAME --file $BACKUP_PATH --auth-mode key

# Restaurar el respaldo en MongoDB
mongorestore --host="$MONGO_CONNECTION_STRING" -u $MONGO_USERNAME -p $MONGO_PASSWORD --gzip --archive=/mongodump/$BACKUP_NAME

#--host $MONGO_HOST --port $MONGO_PORT --gzip --archive=$BACKUP_PATH/$BACKUP_NAME

# Eliminar el archivo de respaldo descargado
rm $BACKUP_PATH/$BACKUP_NAME