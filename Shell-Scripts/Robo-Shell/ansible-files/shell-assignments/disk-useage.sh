#!/bin/bash

DISK_USAGE=$(df -hT | grep -ivE 'tmp|File')
DISK_THRESHOLD=1
message=""

while IFS= read line; do
    usage=$(echo $line | awk '{print $6F}' | cut -d % -f1)
    partition=$(echo $line | awk '{print $1F}')
    if [ $usage -ge $DISK_THRESHOLD ]; then
        message+="High Disk Usage on $partition: $usage <br>"
    fi
done <<<$DISK_USAGE

echo -e "Message: $message"

# echo "$message" | mail -s "Hisk Disk Usage" bhanupadhu21071995@gmail.com

# sh mail.sh "Devops Team" "High Disk Usage" "$message" "bhanupadhu21071995@gmail.com" "ALERT High Disk Usage"
sh mail.sh "DevOps Team" "High Disk Usage" "$message" "singalasreenivasulu55@gmail.com" "ALERT High Disk Usage"
