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
        FILES_TO_DELETE=$(find "$SOURCE_DIR" -type f -mtime +$DAYS_TO_DELETE_OR_ARCHIVE -name "*.log")
        if [ -n "$FILES_TO_DELETE" ]; then
            echo "Deleting files older than $DAYS_TO_DELETE_OR_ARCHIVE days:"
            echo "$FILES_TO_DELETE" | while IFS= read -r file; do
                echo "Deleting file: $file"
                rm -f "$file"
            done
        else
            echo "No files found to delete."
        fi
    elif [ "$ACTION" = "archive" ]; then
        FILES_TO_ARCHIVE=$(find "$SOURCE_DIR" -type f -mtime +$DAYS_TO_DELETE_OR_ARCHIVE -name "*.log")
        if [ -n "$FILES_TO_ARCHIVE" ]; then
            mkdir -p "$DESTINATION"
            tar -czvf "$DESTINATION/archive_files.tar.gz" -C "$SOURCE_DIR" --files-from <(echo "$FILES_TO_ARCHIVE")
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
