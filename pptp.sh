#!/bin/bash

PASSWD="$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 25 ; echo )"

echo "What is the device name of the default interface?"
echo ""
read -p "Interface name: " INTERFACE_NAME

echo "localip 192.168.10.1" >> /etc/pptpd.conf
echo "remoteip 192.168.10.2" >> /etc/pptpd.conf

echo "ms-dns 1.1.1.1" >> /etc/ppp/pptpd-options
echo "nobsdcomp" >> /etc/ppp/pptpd-options
echo "noipx" >> /etc/ppp/pptpd-options
echo "mtu 1490" >> /etc/ppp/pptpd-options
echo "mru 1490" >> /etc/ppp/pptpd-options

echo "boops * $PASSWD *" >> /etc/ppp/chap-secrets

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
iptables -t nat -A POSTROUTING -s 192.168.10.2 -o $INTERFACE_NAME -j MASQUERADE
