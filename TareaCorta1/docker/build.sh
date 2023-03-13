#!/bin/bash
sudo docker login
cd mariadb-client
sudo docker build -t melanysf/mariadb-client .
sudo docker images
sudo docker push melanysf/mariadb-client
