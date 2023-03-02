#!/bin/bash
sudo docker login
cd componente1
sudo docker build -t moisose/componente1 .
sudo docker images
sudo docker push moisose/componente1
cd ..
# cd componente2
# sudo docker build -t username/componente2 .
# sudo docker images
# sudo docker push username/componente2
# cd ..