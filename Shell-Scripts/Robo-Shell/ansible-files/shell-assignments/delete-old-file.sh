#!/bin/bash

SOURCE_DIR="/tmp/shell-scripts"

if [ ! -d $SOURCE_DIR ]; then
    echo -e "$SOURCE_DIR Does not exsits"
else
    echo -e "$SOURCE_DIR exsits"
fi

FILES_TO_FIND=$(find $SOURCE_DIR -type f -mtime +14 -name "*.log")
echo "List of filet to delete: $FILES_TO_FIND"
