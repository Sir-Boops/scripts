#!/bin/bash

# This was written on/for Ubuntu 19.10

# Install Wireguard PPA
yes | add-apt-repository ppa:wireguard/wireguard
apt install wireguard -y

# Setup Wireguard interface
ip link add dev wg0 type wireguard
ip address add dev wg0 192.168.24.1/24

# Setup Wireguard
wg genkey > priv.key
wg pubkey < priv.key > pub.key
read -p "Your this servers public key is: $(cat pub.key)"
PORT=${shuf -i 49152-65535 -n 1}
wg set wg0 listen-port $PORT
read -p "Your servers random port is $(PORT)"
wg set wg0 private-key priv.key
read -p "Please paste your PCs public key here" $RE_PUB
wg set wg0 peer $RE_PUB allowed-ips 0.0.0.0/0
wg showconf wg0 > wg.conf

# Enable NAT
ufw disable
sysctl -w net.ipv4.ip_forward=1
iptables -A FORWARD -i wg0 -j ACCEPT
iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE

# Finally start Wireguard
ip link set up dev wg0
