#!/bin/bash

apt update
export DEBIAN_FRONTEND=noninteractive
apt dist-upgrade -y
apt install -y --no-install-recommends \
    dialog \
    apt-utils \
    sudo \
    curl \
    tzdata \
    iproute2 \
    python3 \
    openssh-server \
    ca-certificates
apt autoclean
apt clean
rm -rf /var/lib/apt/lists/*

case "$(uname -m)" in
amd64 | x86_64)
    ARCH="amd64"
    ;;
*)
    ARCH="arm64"
    ;;
esac

. /etc/os-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | sudo tee /etc/apt/keyrings/salt-archive-keyring.pgp
curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | sudo tee /etc/apt/sources.list.d/salt.sources