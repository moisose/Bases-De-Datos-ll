#!/bin/bash
sudo docker login
cd mariadb-client
sudo docker build -t melanysf/mariadb-client .
sudo docker images
sudo docker push melanysf/mariadb-client

cd ../postgresql-client
sudo docker build -t fiozelaya/postgresql-client .
sudo docker images
sudo docker push fiozelaya/postgresql-client

cd ../mongodb-client
sudo docker build -t fiozelaya/mongodb-client .
sudo docker images
sudo docker push fiozelaya/mongodb-client
