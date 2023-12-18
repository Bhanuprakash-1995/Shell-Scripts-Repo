#!/bin/bash

DISK_USAGE=$(df -hT | grep -ivE 'tmp|file')
DISK_THRESHOLD=1
message=""

while IFS= read line; do
    usage=$(echo $line | awk '{print $6F}' | cut -d % -f1)
    partition=$(echo $line | awk '{print $1F}')
    if [ $usage -ge $DISK_THRESHOLD ]; then
        message+="High disk usage on $partition: $usage\n"
    fi
done <<<$DISK_USAGE

echo -e "Message: $message"

echo "$message" | mail -s "message" bhanupadhu21071995@gmail.com
