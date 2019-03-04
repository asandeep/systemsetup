#!/usr/bin/env bash

PWD=$(pwd)

OS_LINUX="linux"
DIST_UBUNTU="ubuntu"

OS="linux"
OS_DIST="ubuntu"

ANSIBLE_UBUNTU_PPA="ppa:ansible/ansible"

# Set ansible log path
# using env variable DEFAULT_LOG_PATH or config paramter log_path

# Mac OS
# sudo pip install ansible

ANSIBLE_LOCALHOST_CONFIG_STRING="localhost ansible_connection=local ansible_python_interpreter /usr/bin/env python"
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
  # sudo apt-get update
  sudo apt-get install software-properties-common
  sudo apt-add-repository --yes --update $ANSIBLE_UBUNTU_PPA
  sudo apt-get install --yes ansible
}

function generate_ansible_inventory() {
  echo "generating"
  tmp_inventory=$(mktemp --tmpdir=/tmp tmp_inventory.XXXX)
  echo $tmp_inventory
  echo "$ANSIBLE_LOCALHOST_CONFIG_STRING" | tee $tmp_inventory
  return $tmp_inventory
}

function run_playbook() {
  inventory_file=$1
  intractive_mode=$2
  optional_params="--ask-become-pass"

  echo "Inventory file: $inventory_file"
  if [[ -n $intractive_mode ]]; then
    echo "ansible-playbook --step -i $inventory_file $DEFAULT_PLAYBOOK"
    # ansible-playbook --step -i $inventory_file $DEFAULT_PLAYBOOK
  else
    echo "ansible-playbook -i $inventory_file $DEFAULT_PLAYBOOK"
    # ansible-playbook -i $inventory_file $DEFAULT_PLAYBOOK
  fi
}

function cleanup() {
  inventory_file=$1
  rm $inventory_file
}

function main() {
  # install_ansible
  inventory_file=$(generate_ansible_inventory)
  run_playbook $inventory_file
  cleanup $inventory_file
}

main
