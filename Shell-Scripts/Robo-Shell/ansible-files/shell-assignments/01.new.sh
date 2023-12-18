#!/bin/bash

SOURCE_DIR=$1
ACTION=$2
DEFAULT_DAYS_TO_DELETE=14
DAYS_TO_DELETE_OR_ARCHIVE=${3:-$DEFAULT_DAYS_TO_DELETE}
DESTINATION=$4

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
            # Create a temporary file to store the list of files to archive
            TEMP_FILE=$(mktemp /tmp/files_to_archive.XXXXXX)
            echo "$FILES_TO_ARCHIVE" >"$TEMP_FILE"

            mkdir -p "$DESTINATION"
            tar -czvf "$DESTINATION/archive_files.tar.gz" -C "$SOURCE_DIR" -T "$TEMP_FILE"

            # Clean up the temporary file
            rm -f "$TEMP_FILE"
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
