#!/bin/bash

VENV_DIR="$HOME/kolla-venv"

read -p "Enter your TrueNAS root password: " password
echo

mkdir -p /etc/kolla/config/cinder/
cp -rf $HOME/kolla-ansible-deployment/cinder/etc/ /etc/kolla/config/cinder/
sed -i "s/PASSWORD/$password/" /etc/kolla/config/cinder/cinder-volume.conf

cp -f $HOME/kolla-ansible-deployment/cinder/templates/cinder-volume.json.j2 $VENV_DIR/share/kolla-ansible/ansible/roles/cinder/templates
cp -f $HOME/kolla-ansible-deployment/cinder/tasks/* $VENV_DIR/share/kolla-ansible/ansible/roles/cinder/tasks/
