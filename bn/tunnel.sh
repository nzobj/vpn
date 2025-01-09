#!/bin/bash

set -e -o pipefail

function error_exit() {
  echo "Error: $*"
  exit 1
}

function print_help() {
  local name="$(basename "$BASH_SOURCE")"

  echo
  echo "$name MODE TARGET"
  echo
  echo 'Modes:'
  echo
  echo 'p | ping - ping TARGET'
  echo 't | tcp  - connect to TARGET using TCP/IPv4'
  echo 'u | udp  - connect to TARGET using UDP/IPv4'
  echo
  echo 'Examples:'
  echo
  echo "$name p HOST"
  echo "$name t HOST:PORT"
  echo "$name u HOST:PORT"
  echo
}

container_name='vpn-bn'
container_command=()

tcp_port=9000
udp_port=9001

message=

mode="$1"
target="$2"

if [[ -z "$target" ]]
then
  print_help
  exit 1
fi

case "$mode" in
  'p'|'ping')
    container_command+=('ping')
    container_command+=("$target")
    ;;

  't'|'tcp')
    container_command+=(
      'socat'
      "TCP4-LISTEN:$tcp_port,fork"
      "TCP4:$target")
    message="TCP proxy: localhost:$tcp_port"
    ;;

  'u'|'udp')
    container_command+=(
      'socat'
      "UDP4-LISTEN:$udp_port,fork"
      "UDP4:$target"
    )
    message="UDP proxy: localhost:$udp_port"
    ;;

  *)
    print_help
    exit 1
    ;;
esac

[[ -n "$message" ]] && echo "$message"

podman exec \
  --interactive \
  --tty \
  "$container_name" \
  "${container_command[@]}"
