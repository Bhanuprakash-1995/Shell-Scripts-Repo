#!/bin/bash
SOURCE_DIR=$1
ACTION=$2
DEFAULT_DAYS_TO_DELETE=14
DAYS_TO_DELETE=${3:-$DEFAULT_DAYS_TO_DELETE}

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "$R $SOURCE_DIR Does not exsits"
    exit 1
else
    echo -e "$SOURCE_DIR exsits"
fi

if [ "$ACTION" == "delete" ]; then
    FILES_TO_DELETE=$(find "$SOURCE_DIR" -type f -name "*.log" -mtime +"$DAYS_TO_DELETE")

    # Count the number of files found
    FILE_COUNT=$(echo "$FILES_TO_DELETE" | wc -l)

    if [ "$FILE_COUNT" -gt 0 ]; then
        echo "$FILES_TO_DELETE" | while IFS= read -r line; do
            echo -e "Deleting file: $line"
            rm -rf "$line"
        done
    else
        echo "No file to delete for provided duration"
        exit 1
    fi
fi
