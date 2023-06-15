#!/bin/bash
# get the current date and time
DATE=$(date '+%Y%m%d%H%M')
# create a directory with the current date
# the [-p] arg is used bs /pgdump may not exist
mkdir -p /pgdump/$DATE
# Update the packages
apk update
apk upgrade
# Install the PostgreSQL client
apk add postgresql-client
# Azure CLI command for enable dynamic install without a prompt.
az config set extension.use_dynamic_install=yes_without_prompt

# pg_dump configuration for connect to an instance
PGPASSWORD="$POSTGRESQL_PASSWORD" pg_dumpall --host $DB_HOST -U $POSTGRESQL_USERNAME --file=/pgdump/$DATE/db_backup.dump

# Drop all databases except the default ones
#PGPASSWORD="$POSTGRESQL_PASSWORD" psql --host $DB_HOST -U $POSTGRESQL_USERNAME -c "SELECT 'DROP DATABASE IF EXISTS ' || datname || ';' FROM pg_database WHERE datistemplate = false AND datname != 'postgres';" | PGPASSWORD="$POSTGRESQL_PASSWORD" psql --host $DB_HOST -U $POSTGRESQL_USERNAME
# Delete all data from the database
PGPASSWORD="$POSTGRESQL_PASSWORD" psql --host $DB_HOST -U $POSTGRESQL_USERNAME -d $POSTGRESQL_DBNAME -c "SELECT 'DROP TABLE IF EXISTS ' || tablename || ' CASCADE;' FROM pg_tables WHERE schemaname = 'public';" | PGPASSWORD="$POSTGRESQL_PASSWORD" psql --host $DB_HOST -U $POSTGRESQL_USERNAME -d $POSTGRESQL_DBNAME

az storage blob directory upload --container $CONTAINER -s /pgdump/$DATE -d $BACKUP_PATH --auth-mode key --recursive
rm -rf /pgdump/$DATE

