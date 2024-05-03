#!/bin/bash

# Install IPVS (assuming already installed)
# sudo apt-get update
# sudo apt-get install -y ipvsadm

# Add IPVS rules for virtual IP for https
sudo ipvsadm -A -t 192.168.56.13:443 -s rr  # Round Robin scheduling

# Add IPVS rules for virtual IP for http
sudo ipvsadm -A -t 192.168.56.13:80 -s rr  # Round Robin scheduling

# Add load balancer container to IPVS (modify ports accordingly)
sudo ipvsadm -a -t 192.168.56.13:80 -r 172.16.0.2:80 -m
sudo ipvsadm -a -t 192.168.56.13:80 -r 172.16.0.3:80 -m
sudo ipvsadm -a -t 192.168.56.13:443 -r 172.16.0.2:443 -m
sudo ipvsadm -a -t 192.168.56.13:443 -r 172.16.0.3:443 -m

# Check IPVS configuration
sudo ipvsadm -l -n

# Access web server via virtual IP (should cycle through servers)
while true; do curl -k https://192.168.56.13; sleep 1; echo; done