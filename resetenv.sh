#!/bin/bash

sudo snap remove microk8s --purge

cd /opt/dynatrace/gateway

sudo ./uninstall.sh

cd ~

sudo rm -rf *

