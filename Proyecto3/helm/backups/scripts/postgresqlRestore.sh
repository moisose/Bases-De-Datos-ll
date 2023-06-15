#!/bin/bash
BACKUP_FILE="/pgdump/<ruta_del_archivo_de_respaldo>"
apk update
apk upgrade
apk add postgresql-client
az config set extension.use_dynamic_install=yes_without_prompt
PGPASSWORD="$POSTGRESQL_PASSWORD" pg_restore --host $DB_HOST -U $POSTGRESQL_USERNAME --dbname=<nombre_de_base_de_datos_destino> $BACKUP_FILE
