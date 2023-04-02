#!/bin/bash
cd bootstrap
helm dependency build --skip-refresh
cd ../stateful
helm dependency build --skip-refresh
cd ..
helm upgrade --install bootstrap bootstrap
sleep 20
helm upgrade --install stateful stateful
sleep 60
helm upgrade --install stateless stateless