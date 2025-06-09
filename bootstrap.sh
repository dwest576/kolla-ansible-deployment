#!/bin/bash

set -euo pipefail

read -p "Enter your Openstack admin password: " password
echo

# === CONFIGURATION ===
KOLLA_VERSION="stable/2025.1"
PYTHON_VERSION="3.11"
VENV_DIR="$HOME/kolla-venv"
INVENTORY="$HOME/multinode"
NETWORK_IF="931-IoT"  # Adjust this to your primary NIC

echo ">>> [1/12] Updating system and installing core packages..."
sudo dnf update -y
sudo dnf install -y epel-release
sudo dnf install -y dnf-plugins-core git vim gcc make libffi-devel \
  openssl-devel bzip2-devel wget tar libuuid-devel xz-devel \
  zlib-devel readline-devel sqlite-devel ncurses-devel \
  tk-devel libselinux-python3 python3-pip python3-devel ansible-core

echo ">>> [2/12] Installing Python $PYTHON_VERSION..."
sudo dnf install -y python3.11 python3.11-devel

echo ">>> [3/12] Installing pip for Python $PYTHON_VERSION..."
curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.11

echo ">>> [4/12] Creating Python virtualenv at $VENV_DIR..."
python3.11 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

echo ">>> [6/12] Cloning Kolla-Ansible ($KOLLA_VERSION)..."
cd "$HOME"
git clone https://opendev.org/openstack/kolla-ansible.git
cd kolla-ansible
git checkout "$KOLLA_VERSION"

echo ">>> [7/12] Installing Kolla-Ansible in virtualenv..."
pip install -U pip
pip install .

echo ">>> [8/12] Installing Ansible role dependencies..."
kolla-ansible install-deps

echo ">>> [9/12] Setting up configuration..."
sudo mkdir -p /etc/kolla
sudo chown "$USER":"$USER" /etc/kolla
cp -r etc/kolla/* /etc/kolla

echo ">>> [10/12] Generating passwords..."
kolla-genpwd

echo ">>> [12/12] Writing /etc/kolla/globals.yml..."
cp $HOME/kolla-ansible-deployment/globals.yml /etc/kolla/globals.yml
sed -i 's/\(keystone_auth_admin_password:\s*\).*/\1${password}/' /etc/kolla/passwords.yml
