#!/bin/bash
source $(dirname $0)/shared.sh

# Clone Hobo gemset to project gemset
clone_gemset $RUBY_VERSION $HOBO_GEMSET_NAME $GEMSET_NAME
use_gemset $RUBY_VERSION $GEMSET_NAME

# Jenkins creates the workspace as "nobody" (gid -2 on OSX) which is problematic for Vagrant
sudo chgrp wheel `pwd`

# Rebuild to VM unless explicitly instructed not to
if [[ $NO_REBUILD == 1 ]]; then
  hobo vm start
else
  hobo vm rebuild
fi
