#!/bin/bash

# This was written on/for Ubuntu 19.10
PORT=`shuf -i 49152-65535 -n 1`
read -p "Please paste your PCs public key here" RE_PUB

# Install Wireguard PPA
yes | add-apt-repository ppa:wireguard/wireguard
apt install wireguard -y

# Setup Wireguard interface
ip link add dev wg0 type wireguard
ip address add dev wg0 192.168.24.1/24

# Setup Wireguard
wg genkey > priv.key
wg pubkey < priv.key > pub.key
echo "Your this servers public key is: $(cat pub.key)"
wg set wg0 listen-port $PORT
echo "Your servers random port is $PORT"
wg set wg0 private-key priv.key
wg set wg0 peer $RE_PUB allowed-ips 0.0.0.0/0
wg showconf wg0 > wg.conf

# Enable NAT
ufw disable
sysctl -w net.ipv4.ip_forward=1
iptables -A FORWARD -i wg0 -j ACCEPT
iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE

# Enable UPnP
apt install miniupnpd -y
iptables -t nat -N MINIUPNPD
iptables -t nat -A PREROUTING -i ens3 -j MINIUPNPD
iptables -t filter -N MINIUPNPD
iptables -t filter -A FORWARD -i ens3 ! -o ens3 -j MINIUPNPD
echo "To start upnp: miniupnpd -d -1 -i ens3 -a wg0 -A \"allow 1024-65535 192.168.24.0/24 1024-65535\""

# Finally start Wireguard
ip link set up dev wg0



echo "Paste public key now"; read publicKey; ip link; echo "What interface are you using?"; read interFace; apt install wireguard -y; ip link add dev wg0 type wireguard; ip address add dev wg0 192.168.24.1/24; wg genkey > priv.key; wg pubkey < priv.key > pub.key; wg set wg0 listen-port 25565; wg set wg0 private-key priv.key; wg set wg0 peer `echo $publicKey` allowed-ips 0.0.0.0/0; wg showconf wg0 > wg.conf; ufw disable; sysctl -w net.ipv4.ip_forward=1; iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o `echo $interFace` -j MASQUERADE; ip link set up dev wg0; echo ""; echo "Setup is complete this servers public key is:"`cat pub.key`
