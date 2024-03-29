#!/bin/bash
# cd app
# helm dependency build --skip-refresh
# cd ../bootstrap
# helm dependency build --skip-refresh
# cd ../databases
# helm dependency build --skip-refresh
# cd ../grafana-config
# helm dependency build --skip-refresh
# cd ../monitoring-stack
# helm dependency build --skip-refresh
# cd ..
kubectl delete pvc --all --force --grace-period=0 -n default
helm upgrade --install bootstrap bootstrap
sleep 5s
helm upgrade --install monitoring-stack monitoring-stack
sleep 5s
helm upgrade --install databases databases
sleep 30s
helm upgrade --install stateless stateless -f databases/values.yaml
sleep 5s
helm upgrade --install grafana-config grafana-config
