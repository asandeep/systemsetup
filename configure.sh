#!/usr/bin/env bash

PWD=$(pwd)

OS_LINUX="linux"
DIST_UBUNTU="ubuntu"

OS="linux"
OS_DIST="ubuntu"

ANSIBLE_UBUNTU_PPA="ppa:ansible/ansible"

ANSIBLE_LOCALHOST_CONFIG_STRING="localhost ansible_connection=local ansible_python_interpreter=$(which python)"
TMP_INVENTORY_FILE=$(mktemp --tmpdir=/tmp tmp_inventory.XXXX)
echo "$ANSIBLE_LOCALHOST_CONFIG_STRING" | tee $TMP_INVENTORY_FILE > /dev/null

DEFAULT_PLAYBOOK="$PWD/playbooks/setup.yml"

# Post install configuration
# MySQL
# mysql_secure_installation


function install_ansible() {
  if [[ "$OS" = "$OS_LINUX" ]] && [[ "$OS_DIST" = "$DIST_UBUNTU" ]]; then
    echo "Installing ansible"
    install_ansible_ubuntu
  else
    echo "Ansible not installed"
    echo "$OS"
  fi
}

function install_ansible_ubuntu() {
  sudo apt-get install software-properties-common
  sudo apt-add-repository --yes --update $ANSIBLE_UBUNTU_PPA
  sudo apt-get install --yes ansible
}

function run_playbook() {
  intractive_mode=$1
  echo $intractive_mode
  optional_params="--ask-become-pass"

  echo "Inventory file: $TMP_INVENTORY_FILE"
  cat $TMP_INVENTORY_FILE
  if [[ -z $intractive_mode ]]; then
    echo "ansible-playbook --step -i $TMP_INVENTORY_FILE $DEFAULT_PLAYBOOK"
    ansible-playbook --check --ask-become-pass -v -i $TMP_INVENTORY_FILE $DEFAULT_PLAYBOOK
  else
    echo "ansible-playbook -i $TMP_INVENTORY_FILE $DEFAULT_PLAYBOOK"
    ansible-playbook -K -i  $TMP_INVENTORY_FILE $DEFAULT_PLAYBOOK
  fi
}

function cleanup() {
  rm $TMP_INVENTORY_FILE
}

function main() {
  install_ansible
  run_playbook
  cleanup
}

main
