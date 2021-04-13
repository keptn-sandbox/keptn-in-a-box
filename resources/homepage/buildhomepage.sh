#!/bin/bash

# we build the image and tag it
docker build -t shinojosa/kiab:0.8 .

# Pushit to dockerhub
docker push shinojosa/kiab:0.8