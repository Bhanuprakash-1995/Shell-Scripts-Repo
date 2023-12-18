#!/bin/bash

file="/etc/passwd"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ ! -f $file ]; then
    echo -e "$R $file Does not exists $N"
    exit 1
fi

while IFS=: read -r username password user_id group_id; do
    echo "Username: $username"
    echo "Password: $password"
    echo "user_id: $user_id"
    echo "group_id: $group_id"
done <$file
