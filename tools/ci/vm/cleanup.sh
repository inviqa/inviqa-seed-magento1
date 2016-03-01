#!/bin/bash -eux
source $(dirname $0)/shared.sh

hem vm destroy
rm -rf .gems
