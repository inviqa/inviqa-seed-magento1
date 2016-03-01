#!/bin/bash -eux
source $(dirname $0)/shared.sh

# Jenkins creates the workspace as "nobody" (gid -2 on OSX) which is problematic for Vagrant
sudo chgrp wheel `pwd`

# Rebuild to VM unless explicitly instructed not to
if [[ $NO_REBUILD == 1 ]]; then
  hem vm up
else
  hem vm rebuild
fi
