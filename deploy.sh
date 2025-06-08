#!/bin/bash

set -euo pipefail

# === CONFIGURATION ===
KOLLA_VERSION="stable/2025.1"
PYTHON_VERSION="3.11"
VENV_DIR="$HOME/kolla-venv"
INVENTORY="$HOME/kolla-ansible-deployment/multinode"
NETWORK_IF="931-IoT"  # Adjust this to your primary NIC

echo ">>> [4/12] Creating Python virtualenv at $VENV_DIR..."
python3.11 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"


echo ">>> 🚀 Starting Kolla-Ansible deployment (this will take a while)..."
kolla-ansible bootstrap-servers -i "$INVENTORY"
kolla-ansible prechecks -i "$INVENTORY"
kolla-ansible deploy -i "$INVENTORY"
kolla-ansible post-deploy -i "$INVENTORY"

source /etc/kolla/admin-openrc.sh

echo
echo "✅ OpenStack 2025.1 (Envoy) successfully deployed!"
echo "🌐 Horizon Dashboard: http://openstack.931.tech/"
echo "🔐 Admin Password: $(grep keystone_admin_password /etc/kolla/passwords.yml | awk '{print $2}')"