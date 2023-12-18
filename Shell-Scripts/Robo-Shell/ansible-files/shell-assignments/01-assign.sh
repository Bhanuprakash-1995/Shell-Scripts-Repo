#!/bin/bash
SOURCE_DIR=$1
ACTION=$2
DEFAULT_DAYS_TO_DELETE=14
DAYS_TO_DELETE=${3:-$DEFAULT_DAYS_TO_DELETE}
DEST=$4

if [ $ACTION == "delete" ]; then
    if [ -d $SOURCE_DIR ]; then
        echo "Directory is exist"
    fi
fi
