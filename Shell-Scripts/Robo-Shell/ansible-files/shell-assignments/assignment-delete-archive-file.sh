#!/bin/bash
SOURCE_DIR=$1

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

FILES_TO_FIND=$(find $SOURCE_DIR -type f -mtime +14 -name "*.log")

if [ ! $FILES_TO_FIND ]; then
    echo "There no files to delete"
    exit 1
else
    echo "List of filet to delete: $FILES_TO_FIND"
fi

while IFS= read -r line; do
    echo -e "Deleting file: $line"
    rm -rf $line
done <<<$FILES_TO_FIND
