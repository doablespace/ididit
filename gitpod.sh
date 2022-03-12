#!/bin/bash
# This script contains commands run in Gitpod.

# Fail on first error
set -e

# Start Tailscale proxy.
sudo tailscaled --tun=userspace-networking &> /workspace/tailscaled.out.txt &
(sudo tailscale up --hostname gitpod-ididit && tailscale ip -4) &

./entrypoint.sh
