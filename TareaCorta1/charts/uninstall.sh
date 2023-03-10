#!/bin/bash
helm uninstall grafana-config
sleep 5
helm uninstall databases
sleep 5
helm uninstall monitoring-stack
sleep 5
helm uninstall bootstrap