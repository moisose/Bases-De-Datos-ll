sudo docker login
cd Loader
sudo docker build --build-arg ENV_FILE=envVar.env  -t melanysf/loader-p2 .
#sudo docker build --env-file envVar.env -t melanysf/loader-p2 .
#sudo docker build -t melanysf/loader-p2 .
#sudo docker run --env-file envVar.env melanysf/loader-p2
#sudo docker images
sudo docker push melanysf/loader-p2