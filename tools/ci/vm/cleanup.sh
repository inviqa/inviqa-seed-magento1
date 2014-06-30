#!/bin/bash
source $(dirname $0)/shared.sh 

use_gemset $RUBY_VERSION $GEMSET_NAME
hobo vm destroy
delete_gemset $RUBY_VERSION $GEMSET_NAME
