#!/bin/bash -eux
source $(dirname $0)/shared.sh

cd tools/vagrant
bundle exec rake
