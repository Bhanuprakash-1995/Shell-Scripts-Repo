#!/bin/bash
SOURCE_DIR=$1
ACTION=$2
DEFAULT_DAYS_TO_DELETE=14
# DEFAULT_DAYS_TO_ARCHIVE=14
DAYS_TO_DELETE=${3:-$DEFAULT_DAYS_TO_DELETE}
# DEST=${4:-$DEFAULT_DAYS_TO_ARCHIVE}

if [ -d "$SOURCE_DIR" ] && [ "$ACTION" = "delete" ]; then
    FILES_TO_FIND=$(find $SOURCE_DIR -type f -mtime +$DAYS_TO_DELETE -name "*.log")
    FILE_COUNT=$(echo "$FILES_TO_FIND" | wc -l)
    if [ "$FILE_COUNT" -gt 0 ]; then
        while IFS= read -r line; do
            echo -e "Deleting file: $line"
            rm -rf $line
        done <<<$FILES_TO_FIND
    fi
else
    echo "Directory doesn't exist or action is not set to delete."
fi
