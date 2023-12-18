#!/bin/bash
SOURCE_DIR=$1
ACTION=$2
DEFAULT_DAYS_TO_DELETE=14
DAYS_TO_DELETE=${3:-$DEFAULT_DAYS_TO_DELETE}
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

# Rest of your script

# Use DAYS_TO_DELETE in your file deletion operation
if [ "$ACTION" == "delete" ]; then
    FILES_TO_DELETE=$(find "$SOURCE_DIR" -type f -name "*.log" -mtime +"$DAYS_TO_DELETE")
    echo "$FILES_TO_DELETE files to delete"
    echo "User chose to delete the files older than $DAYS_TO_DELETE days"
    if [ -n "$FILES_TO_DELETE" ]; then
        while IFS= read -r line; do
            echo -e "Deleting file: $line"
            rm -rf "$line"
        done <<<"$FILES_TO_DELETE"
    fi
fi

#/tmp/shell-scripts
