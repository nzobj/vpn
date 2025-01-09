#!/bin/bash

set -e -o pipefail -x

# Servers:
# - bncv9045.bn.ch (10.144.53.45)
# - bncv9046.bn.ch (10.144.53.46)
# - bncv9047.bn.ch (10.144.53.47)

server='10.144.53.47'
server_name='bncv9047.bn.ch'
user='nzus'
domain='BN'
size='1920x1080'

# Use german keyboard layout:
keyboard_layout=0x00000407

read -sp "Password: " password

flatpak run com.freerdp.FreeRDP \
  "/v:$server" \
  "/u:$user" \
  "/p:$password" \
  "/d:$domain" \
  "/size:$size" \
  '/sec:tls' \
  "/server-name:$server_name" \
  "/kbd:layout:$keyboard_layout"
