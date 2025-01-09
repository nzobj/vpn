from docker.io/library/alpine

# Packages:
#   - bash        - required for script execution and to not have to use sh
#   - openconnect - required for configuring the VPN (cisco anyconnect)
#   - socat       - required for creating tunnels from host to VPN

run \
  apk update && \
  apk add --no-cache \
    bash \
    iptables \
    openconnect \
    socat

copy entrypoint.sh /mnt/
copy vpnc-hook-post-connect.sh /etc/vpnc/post-connect.d/

run \
  chmod +x /mnt/entrypoint.sh

entrypoint ["/mnt/entrypoint.sh"]
