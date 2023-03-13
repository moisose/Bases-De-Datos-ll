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
helm upgrade --install bootstrap bootstrap
sleep 5
helm upgrade --install monitoring-stack monitoring-stack
sleep 5
helm upgrade --install databases databases
sleep 60
helm upgrade --install stateless stateless
sleep 5
helm upgrade --install grafana-config grafana-config