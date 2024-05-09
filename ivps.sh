#!/bin/bash

# Install IPVS (assuming already installed)
# uncomment the following lines if IPVS is not installed
# sudo apt-get update
# sudo apt-get install -y ipvsadm

# Define virtual IP address
VIRTUAL_IP="192.168.56.13"

# Define LB server IPs (modify these as needed)
LB_SERVER_IPS=(172.16.0.2 172.16.0.3)

# Add IPVS rules for HTTPS and HTTP with Round Robin scheduling
for PORT in 80 443; do
  sudo ipvsadm -A -t "$VIRTUAL_IP:$PORT" -s rr
  for SERVER_IP in "${LB_SERVER_IPS[@]}"; do
    sudo ipvsadm -a -t "$VIRTUAL_IP:$PORT" -r "$SERVER_IP:$PORT" -m
  done
done

# Check IPVS configuration
sudo ipvsadm -l -n

# Access web server via virtual IP (round robin through servers)
while true; do
  curl -k "https://$VIRTUAL_IP"
  sleep 1
  echo
done

# curl -k "https://192.168.56.13"