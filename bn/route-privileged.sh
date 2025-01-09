#!/bin/bash

set -e -o pipefail -x

[[ "$UID" -eq 0 ]] || exit 1

container_name="$1"
container_ip="$2"
vpn_net="$3"
vpn_dns="$4"
vpn_domain="$5"

vpn_net='10.144.0.0/16'

[[ -n "$container_name" ]] || exit 1
[[ -n "$container_ip" ]] || exit 1
[[ -n "$vpn_net" ]] || exit 1
[[ -n "$vpn_dns" ]] || exit 1
[[ -n "$vpn_domain" ]] || exit 1

ip_forward_path='/proc/sys/net/ipv4/ip_forward'
ip_forward="$(cat "$ip_forward_path")"

function route() {
  ip route "$1" "$2" via "$container_ip"
}

function start_routing() {
  [[ "$ip_forward" -eq 0 ]] && echo 1 > "$ip_forward_path"

  route add "$vpn_net"

#  for i in $vpn_dns
#  do
#    route add "$i"
#  done
}

function stop_routing() {
  route del "$vpn_net" || true

#  for i in $vpn_dns
#  do
#    route del "$i"
#  done

  [[ "$ip_forward" -eq 0 ]] && echo 0 > "$ip_forward_path"
}

start_routing

trap stop_routing EXIT

sleep infinity
