#!/bin/bash

# Return on error
set -e

# Overwrite global SSH configuration
echo "Host *
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
" > /etc/ssh/ssh_config
