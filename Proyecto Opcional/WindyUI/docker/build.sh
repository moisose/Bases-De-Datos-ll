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

sudo docker build -t fiozelaya/countries-cronjob .
sudo docker images
sudo docker push fiozelaya/countries-cronjob

cd ..
cd StatesCronjob

sudo docker build -t fiozelaya/states-cronjob .
sudo docker images
sudo docker push fiozelaya/states-cronjob

cd ..
cd StationsCronjob

sudo docker build -t fiozelaya/stations-cronjob .
sudo docker images
sudo docker push fiozelaya/stations-cronjob

cd ..
cd mariadb-client

sudo docker build -t fiozelaya/mariadbclient .
sudo docker images
sudo docker push fiozelaya/mariadbclient

kubectl apply -f countriesCronjob.yaml
kubectl apply -f statesCronjob.yaml
kubectl apply -f stationsCronjob.yaml
kubectl apply -f mariadb-db.yaml