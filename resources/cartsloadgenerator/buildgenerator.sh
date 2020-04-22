#!/bin/bash

# Build loadgenerator
docker build . -t shinojosa/cartsloadgen:keptn

# we push the image into the cluster repository
docker push shinojosa/cartsloadgen:keptn

