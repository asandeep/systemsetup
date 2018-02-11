# Ubuntu
sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible

# Mac OS
sudo pip install ansible

mkdir ~/ansible
touch ~/ansible/hosts
echo "localhost ansible_connection=local ansible_python_interpreter /usr/bin/env python"

# Either set this or directly pass inventory file using -i option
export ANSIBLE_INVENTORY=~/ansible/hosts
