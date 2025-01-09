#!/bin/bash

set -e -o pipefail

function error_exit() {
  echo "Error: $*"
  exit 1
}

base_path="$(dirname "$BASH_SOURCE")"

container_name='vpn-bn'
image_name='vpn-bn'

vpn_client_base_path='/mnt/data/files/bank-now/vpn/27C73E7078A0225D7D8513AE0D7D13647C98D130'

# Path to client certificate (PEM format):
vpn_client_crt="$vpn_client_base_path.crt"

# Path to client private key (PEM format):
vpn_client_key="$vpn_client_base_path.key"

vpn_url='https://ras-int.bn-direct.ch'

[[ -f "$vpn_client_crt" ]] || error_exit "Cannot find client certificate: $vpn_client_crt"
[[ -f "$vpn_client_key" ]] || error_exit "Cannot find client key: $vpn_client_key"

podman build \
  --tag "$image_name" \
  "$base_path/container"

VPN_CLIENT_CRT=/mnt/client.crt
VPN_CLIENT_KEY=/mnt/client.key

container_env=()
container_mounts=()

container_env+=('--env' "VPN_CLIENT_CRT=$VPN_CLIENT_CRT")
container_env+=('--env' "VPN_CLIENT_KEY=$VPN_CLIENT_KEY")
container_env+=('--env' "VPN_URL=$vpn_url")

container_mounts+=('--mount' "type=bind,source=$vpn_client_crt,target=$VPN_CLIENT_CRT,ro")
container_mounts+=('--mount' "type=bind,source=$vpn_client_key,target=$VPN_CLIENT_KEY,ro")

podman run \
  --name "$container_name" \
  --interactive \
  --privileged \
  --rm \
  --tty \
  -p '9000:9000/tcp' \
  -p '9001:9001/udp' \
  "${container_env[@]}" \
  "${container_mounts[@]}" \
  "$image_name"
