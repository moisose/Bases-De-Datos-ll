#!/bin/bash
cd bootstrap
helm repo add elastic https://helm.elastic.co
helm dependency build --skip-refresh
cd ../databases
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus https://prometheus-community.github.io/helm-charts
helm dependency build --skip-refresh
cd ../monitoring-stack
helm repo add bitnami https://charts.bitnami.com/bitnami
helm dependency build --skip-refresh