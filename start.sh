#!/bin/bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Expect host sysctls to be pre-set:
#   sudo sysctl -w net.ipv4.conf.all.src_valid_mark=1
#   sudo sysctl -w net.ipv4.ip_forward=1

docker stop amneziawg-client >/dev/null 2>&1 || true
docker rm amneziawg-client >/dev/null 2>&1 || true

docker run -dit \
  --name=amneziawg-client \
  --privileged \
  -v "${PROJECT_ROOT}/config:/config" \
  --device=/dev/net/tun:/dev/net/tun \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv4.ip_forward=1" \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  --restart always \
  amneziawg-client-local
