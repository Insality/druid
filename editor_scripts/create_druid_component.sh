#!/bin/bash
# @license MIT, Insality 2022
# @source https://github.com/Insality/druid

echo "Run bash for $1"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

is_defree_installed=$(pip3 list --disable-pip-version-check | grep -E "deftree")
if [ -z "$is_defree_installed" ]; then
    echo "The python deftree is not installed. Installing..."
    pip3 install deftree
fi

python3 $DIR/create_druid_component.py $@
