#!/bin/bash
sudo docker login
cd componente1
sudo docker build -t moisose/componente1 .
sudo docker images
sudo docker push moisose/componente1

cd ..
cd componente2

sudo docker build -t moisose/componente2 .
sudo docker images
sudo docker push moisose/componente2

# cd componente2
# sudo docker build -t username/componente2 .
# sudo docker images
# sudo docker push username/componente2
# cd ..

cd ..
cd CountriesCronjob

sudo docker build -t moisose/countries-cronjob .
sudo docker images
sudo docker push moisose/countries-cronjob

cd ..
cd StatesCronjob

sudo docker build -t moisose/states-cronjob .
sudo docker images
sudo docker push moisose/states-cronjob

cd ..
cd StationsCronjob

sudo docker build -t moisose/stations-cronjob .
sudo docker images
sudo docker push moisose/stations-cronjob

cd ..
cd mariadb-client

sudo docker build -t moisose/mariadbclient .
sudo docker images
sudo docker push moisose/mariadbclient

