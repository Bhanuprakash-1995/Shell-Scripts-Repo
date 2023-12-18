#!/bin/bash

SOURCE_DIR="/tmp/shell-scripts"

if [ ! -d $SOURCE_DIR ]; then
    echo -e "$SOURCE_DIR Does not exsits"
else
    echo -e "$SOURCE_DIR exsits"
fi
