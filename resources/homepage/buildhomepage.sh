#!/bin/bash

# we build the image and tag it
docker build -t shinojosa/nginxacm:0.7.3 .

# Pushit to dockerhub
docker push shinojosa/nginxacm:0.7.3