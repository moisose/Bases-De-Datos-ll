sudo docker login
#cd app
sudo docker build -t fiozelaya/countries-cronjob .
sudo docker images
sudo docker push fiozelaya/countries-cronjob

sudo docker build -t fiozelaya/states-cronjob .
sudo docker images
sudo docker push fiozelaya/states-cronjob

sudo docker build -t fiozelaya/stations-cronjob .
sudo docker images
sudo docker push fiozelaya/stations-cronjob

kubectl apply -f countriesCronjob.yaml
kubectl apply -f statesCronjob.yaml
kubectl apply -f stationsCronjob.yaml