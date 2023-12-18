#!/bin/bash
SOURCE_DIR=$1
ACTION=$2
DEFAULT_DAYS_TO_DELETE=14
DEFAULT_DAYS_TO_ARCHIVE=14
DAYS_TO_DELETE_ARCHIVE=${3:-$DEFAULT_DAYS_TO_DELETE}
DESTINATION=$4

if [ -d "$SOURCE_DIR" ] && [ "$ACTION" = "delete" ]; then
    FILES_TO_FIND=$(find $SOURCE_DIR -type f -mtime +$DAYS_TO_DELETE_ARCHIVE -name "*.log")
    FILE_COUNT=$(echo "$FILES_TO_FIND" | wc -l)
    if [ "$FILE_COUNT" -gt 0 ]; then
        while IFS= read -r line; do
            echo -e "Deleting file: $line"
            rm -rf $line
        done <<<$FILES_TO_FIND
    fi
else
    echo "Directory doesn't exist."
    exit 1
fi

if [ -d "$SOURCE_DIR" ] && [ "$ACTION" = "archive" ]; then
    mkdir -d $DESTINATION
    FILES_TO_FIND=$(find $SOURCE_DIR -type f -mtime +$DAYS_TO_DELETE -name "*.log")
    FILE_COUNT=$(echo "$FILES_TO_FIND" | wc -l)
    if [ "$FILE_COUNT" -gt 0 ]; then
        while IFS= read -r line; do
            zip "$DESTINATION.archive.zip" $line
        done <<<$FILES_TO_FIND
    fi

fi
