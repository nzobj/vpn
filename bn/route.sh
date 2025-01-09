#!/bin/bash

set -e -o pipefail -x

function error_exit() {
  echo "Error: $*"
  exit 1
}

container_name='vpn-bn'
container_ip="$(podman inspect --format '{{.NetworkSettings.IPAddress}}' "$container_name")"

[[ -n "$container_ip" ]] || error_exit 'Cannot determine VPN container IP address'

function get_vpn_config() {
  local path="~/.config/vpn-$1"
  local script="echo \$(cat $path)"

  podman exec "$container_name" /bin/sh -c "$script"
}

vpn_net="$(get_vpn_config net)"
vpn_dns="$(get_vpn_config dns)"
vpn_domain="$(get_vpn_config domain)"

[[ -n "$vpn_net" ]] || error_exit 'Cannot determine VPN network'
[[ -n "$vpn_dns" ]] || error_exit 'Cannot determine VPN DNS'
[[ -n "$vpn_domain" ]] || error_exit 'Cannot determine VPN domain'

sudo "$(dirname "$BASH_SOURCE")/route-privileged.sh" "$container_name" "$container_ip" "$vpn_net" "$vpn_dns" "$vpn_domain"
