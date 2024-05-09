#!/bin/bash

# Run Docker Compose to build the images and run them in a dcoker network
docker compose up

# Check the status of the high-availability load-balancer:
curl https://172.16.0.2
curl https://172.16.0.3