#!/bin/bash

set -e -o pipefail

if [[ ! -f "$VPN_CLIENT_CRT" ]]
then
  echo 'Missing VPN_CLIENT_CRT'
  exit 1
fi

if [[ ! -f "$VPN_CLIENT_KEY" ]]
then
  echo 'Missing VPN_CLIENT_KEY'
  exit 1
fi

if [[ -z "$VPN_URL" ]]
then
  echo 'Missing VPN_URL'
  exit 1
fi

openconnect \
  --protocol=anyconnect \
  --certificate "$VPN_CLIENT_CRT" \
  --sslkey "$VPN_CLIENT_KEY" \
  "$VPN_URL"
