#!/bin/bash
sudo docker login
cd mariadb-client
sudo docker build -t moisose/mariadb-client .
sudo docker images
sudo docker push moisose/mariadb-client

cd ../mariadb-galera-client
sudo docker build -t moisose/mariadb-galera-client .
sudo docker images
sudo docker push moisose/mariadb-galera-client

cd ../postgresql-client
sudo docker build -t moisose/postgresql-client .
sudo docker images
sudo docker push moisose/postgresql-client

cd ../mongodb-client
sudo docker build -t moisose/mongodb-client .
sudo docker images
sudo docker push moisose/mongodb-client

cd ../../APIs/mariadb
sudo docker build -t moisose/apimariadb -f Dockerfile ../.
#sudo docker build -t fiozelaya/apimariadb .
sudo docker images
sudo docker push moisose/apimariadb
