#!/bin/bash
DEFAULT_DAYS_TO_DELETE=14
DAYS_TO_DELETE=${2:-$DEFAULT_DAYS_TO_DELETE}
SOURCE_DIR=$1
echo "$DAYS_TO_DELETE ...!"
FILES_TO_DELETE=$(find "$SOURCE_DIR" -type f -name "*.log" -mtime +"$DAYS_TO_DELETE" -print)
echo "$FILES_TO_DELETE files to delete..!"
