#!/bin/sh

mkdir ~/.config

echo "$INTERNAL_IP4_NETADDR/$INTERNAL_IP4_NETMASKLEN" > ~/.config/vpn-net
echo "$INTERNAL_IP4_DNS" > ~/.config/vpn-dns
echo "$CISCO_DEF_DOMAIN" > ~/.config/vpn-domain

echo 1 > /proc/sys/net/ipv4/ip_forward

iptables -t nat -A POSTROUTING -o "$TUNDEV" -j MASQUERADE
