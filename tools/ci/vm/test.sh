#!/bin/bash
source $(dirname $0)/shared.sh

use_gemset $RUBY_VERSION $GEMSET_NAME
cd tools/vagrant
rake
