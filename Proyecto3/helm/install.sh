kubectl delete pvc --all --force --grace-period=0 -n default
helm upgrade --install boostrap boostrap
sleep 5s
helm upgrade --install databases databases
sleep 60s
helm upgrade --install backups backups