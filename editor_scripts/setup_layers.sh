#!/bin/bash
# @license MIT, Insality 2020
# @source https://github.com/Insality/druid

echo "Run bash for $1"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

/usr/local/bin/python3.7 $DIR/setup_layers.py $@