#!/bin/bash
cd ~/git/abbey-root/ansible || exit 1
ansible-playbook playbooks/site.yml
