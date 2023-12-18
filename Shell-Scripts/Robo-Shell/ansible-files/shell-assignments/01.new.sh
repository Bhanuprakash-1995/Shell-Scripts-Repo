#!/bin/bash

SOURCE_DIR=$1
ACTION=$2
DEFAULT_DAYS_TO_DELETE=14
DAYS_TO_DELETE_OR_ARCHIVE=${4:-$DEFAULT_DAYS_TO_DELETE}
DESTINATION=$3

if [ -z "$DESTINATION" ] && [ "$ACTION" = "archive" ]; then
    echo "Destination argument is mandatory for 'archive' action."
    exit 1
fi

if [ -d "$SOURCE_DIR" ]; then
    if [ "$ACTION" = "delete" ]; then
        FILES_TO_FIND=$(find "$SOURCE_DIR" -type f -mtime +$DAYS_TO_DELETE_OR_ARCHIVE -name "*.log")
        FILE_COUNT=$(echo "$FILES_TO_FIND" | wc -l)
        if [ "$FILE_COUNT" -gt 0 ]; then
            while IFS= read -r line; do
                echo -e "Deleting file: $line"
                rm -rf "$line"
            done <<<"$FILES_TO_FIND"
        else
            echo "No files found to delete."
        fi
    elif [ "$ACTION" = "archive" ]; then
        mkdir -p "$DESTINATION"
        FILES_TO_FIND=$(find "$SOURCE_DIR" -type f -mtime +$DAYS_TO_DELETE_OR_ARCHIVE -name "*.log")
        FILE_COUNT=$(echo "$FILES_TO_FIND" | wc -l)
        if [ "$FILE_COUNT" -gt 0 ]; then
            tar -czvf "$DESTINATION/archive_files.tar.gz" $FILES_TO_FIND
        else
            echo "No files found to archive."
        fi
    else
        echo "Invalid action. Choose either 'delete' or 'archive'."
        exit 1
    fi
else
    echo "Directory '$SOURCE_DIR' doesn't exist."
    exit 1
fi
