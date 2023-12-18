#!/bin/bash
SOURCE_DIR=$1
ACTION=$2
OLD_DATA_TIME=${14:-"default_action"}
# echo "$@ these are the arguments passed"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ ! -d $SOURCE_DIR ]; then
    echo -e "$R $SOURCE_DIR Does not exsits"
    exit 1
else
    echo -e "$SOURCE_DIR exsits"
fi

if [ "$ACTION" == "delete" ]; then
    FILES_TO_DELETE=$(find "$SOURCE_DIR" -type f -mtime +$OLD_DATA_TIME -name "*.log")
    echo "User chose to delete the files"
    if [ -n "$FILES_TO_DELETE" ]; then
        while IFS= read -r line; do
            echo -e "Deleting file: $line"
            rm -rf "$line"
        done <<<"$FILES_TO_DELETE"
    fi
fi
