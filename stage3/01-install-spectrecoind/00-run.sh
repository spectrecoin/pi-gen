#!/bin/bash -e
SPECTRECOIN_VERSION=v2.0.6

# ============================================================================
# Install Spectrecoin binaries
wget https://github.com/spectrecoin/spectre/releases/download/${SPECTRECOIN_VERSION}/Spectrecoin-${SPECTRECOIN_VERSION}-RaspberryPi.tgz
tar xzf Spectrecoin-${SPECTRECOIN_VERSION}-RaspberryPi.tgz

#install -v -o 1000 -g 1000 -m 744 usr/local/bin/spectrecoin     "${ROOTFS_DIR}/usr/local/bin/"
install -v -o 1000 -g 1000 -m 744 usr/local/bin/spectrecoind    "${ROOTFS_DIR}/usr/local/bin/"

rm -f /tmp/Spectrecoin-${SPECTRECOIN_VERSION}-RaspberryPi.tgz
rm -rf usr/

# ============================================================================
# Bootstrap blockchain
git clone https://github.com/spectrecoin/spectrecoin-blockchain-bootstrap.git

install -d -o 1000 -g 1000 -m 755 "${ROOTFS_DIR}/home/pi/.spectrecoin/"
install -d -o 1000 -g 1000 -m 755 "${ROOTFS_DIR}/home/pi/.spectrecoin/txleveldb/"

install -v -o 1000 -g 1000 -m 600 spectrecoin-blockchain-bootstrap/txleveldb/*  "${ROOTFS_DIR}/home/pi/.spectrecoin/txleveldb/"
install -v -o 1000 -g 1000 -m 600 spectrecoin-blockchain-bootstrap/blk0001.dat  "${ROOTFS_DIR}/home/pi/.spectrecoin/"

rm -rf spectrecoin-blockchain-bootstrap

# ============================================================================
# Install Spectrecoin-RPC-UI
git clone https://github.com/HLXEasy/spectre-rpc-sh-ui.git

install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/spectrecoin-rpc-sh-ui"
install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/spectrecoin-rpc-sh-ui/include"
install -d -o 1000 -g 1000 "${ROOTFS_DIR}/home/pi/spectrecoin-rpc-sh-ui/sample_config_daemon"
install -v -o 1000 -g 1000 -m 644 spectre-rpc-sh-ui/include/*               "${ROOTFS_DIR}/home/pi/spectrecoin-rpc-sh-ui/include/"
install -v -o 1000 -g 1000 -m 644 spectre-rpc-sh-ui/sample_config_daemon/*  "${ROOTFS_DIR}/home/pi/spectrecoin-rpc-sh-ui/sample_config_daemon"
install -v -o 1000 -g 1000 -m 644 spectre-rpc-sh-ui/readme.txt              "${ROOTFS_DIR}/home/pi/spectrecoin-rpc-sh-ui/readme.txt"
install -v -o 1000 -g 1000 -m 644 spectre-rpc-sh-ui/script.conf             "${ROOTFS_DIR}/home/pi/spectrecoin-rpc-sh-ui/script.conf"
install -v -o 1000 -g 1000 -m 755 spectre-rpc-sh-ui/spectre_rpc_ui.sh       "${ROOTFS_DIR}/home/pi/spectrecoin-rpc-sh-ui/spectre_rpc_ui.sh"

# Use config from RPC-UI also on wallet
install -v -o 1000 -g 1000 -m 644 spectre-rpc-sh-ui/sample_config_daemon/spectrecoin.conf  "${ROOTFS_DIR}/home/pi/.spectrecoin/"

rm -rf spectre-rpc-sh-ui/
