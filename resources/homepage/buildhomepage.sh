#!/bin/bash

# we build the image and tag it
docker build -t shinojosa/nginxacm .

# Pushit to dockerhub
docker push shinojosa/nginxacm