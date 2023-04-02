#!/bin/bash
helm uninstall stateless
sleep 20
helm uninstall stateful
sleep 60
helm uninstall bootstrap
