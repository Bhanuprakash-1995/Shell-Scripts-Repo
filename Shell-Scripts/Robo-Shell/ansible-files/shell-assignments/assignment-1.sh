#!/bin/bash
SOURCE_DIR=$1
ACTION=$2
DEFAULT_DAYS_TO_DELETE=14
DAYS_TO_DELETE=${1:-$DEFAULT_DAYS_TO_DELETE}
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
if ! [[ $DAYS_TO_DELETE =~ ^[0-9]+$ ]]; then
    echo "Invalid or no numeric value provided. Using default value: $DEFAULT_DAYS_TO_DELETE"
    DAYS_TO_DELETE=$DEFAULT_DAYS_TO_DELETE
fi

# Rest of your script

# Use DAYS_TO_DELETE in your file deletion operation
if [ "$ACTION" == "delete" ]; then
    FILES_TO_DELETE=$(find "$SOURCE_DIR" -type f -name "*.log" -mtime +"$DAYS_TO_DELETE")
    echo "User chose to delete the files older than $DAYS_TO_DELETE days"
    if [ -n "$FILES_TO_DELETE" ]; then
        while IFS= read -r line; do
            echo -e "Deleting file: $line"
            rm -rf "$line"
        done <<<"$FILES_TO_DELETE"
    fi
fi
