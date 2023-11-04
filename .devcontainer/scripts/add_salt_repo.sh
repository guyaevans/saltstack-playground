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
curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring-2023.gpg https://repo.saltproject.io/salt/py3/${ID}/${VERSION_ID}/${ARCH}/SALT-PROJECT-GPG-PUBKEY-2023.gpg
cat <<_EOF >/etc/apt/sources.list.d/salt.list
deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=${ARCH}] https://repo.saltproject.io/salt/py3/${ID}/${VERSION_ID}/${ARCH}/3006 ${VERSION_CODENAME} main
_EOF
