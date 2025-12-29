#!/usr/bin/env -S bash -euo pipefail

# Overwrite global SSH configuration
echo "Host *
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
" > /etc/ssh/ssh_config
