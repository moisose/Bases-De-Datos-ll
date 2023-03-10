#!/bin/bash
sudo docker login
cd orchestratorCronjob
sudo docker build -t moisose/orchestrator-cronjob .
sudo docker images
sudo docker push moisose/orchestrator-cronjob

cd ..
cd processorDeployment

sudo docker build -t moisose/processor-deployment .
sudo docker images
sudo docker push moisose/processor-deployment

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

