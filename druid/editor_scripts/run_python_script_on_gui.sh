#!/bin/bash
# @license MIT, Insality 2022
# @source https://github.com/Insality/druid

echo "Run bash for $1"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Check if pip3 is installed
if command -v pip3 &> /dev/null; then
    PIP_CMD="pip3"
    PYTHON_CMD="python3"
else
    PIP_CMD="pip"
    PYTHON_CMD="python"
fi

is_defree_installed=$($PIP_CMD list --disable-pip-version-check | grep -E "deftree")
if [ -z "$is_defree_installed" ]; then
    echo "The python deftree is not installed. Please install it via"
    echo "$ $PIP_CMD install deftree"
    exit 0
fi

$PYTHON_CMD $1 $2
