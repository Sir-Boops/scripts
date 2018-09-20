#!/bin/bash

# Get addr to forward to
echo "What IP are you forwarding to?"
echo ""
read -p "IP address: " IP_ADDRESS
clear

# Get public IP
echo "What is your public IP?"
echo ""
read -p "Public IP: " PUBLIC_IP

# Get TCP ports to forward
echo "What TCP ports do you wish to forward"
echo "Example 80 53 500"
read -p "TCP ports: " TCP_PORTS
clear

# Get UDP Ports to forward
echo "What UDP ports do you wish to forward"
echo "Example 53 54 55"
read -p "UDP ports: " UDP_PORTS
clear

# Loop over and forward all the tcp ports
for PORT in $TCP_PORTS; do
  iptables -t nat -A PREROUTING -p tcp --dport $PORT -j DNAT --destination $PUBLIC_IP --to-destination $IP_ADDRESS:$PORT
done

# Loop over and forward all the UDP ports
for PORT in $UDP_PORTS; do
  iptables -t nat -A PREROUTING -p udp --dport $PORT -j DNAT --destination $PUBLIC_IP --to-destination $IP_ADDRESS:$PORT
done
