#!/bin/bash

ID=$(id -u)

if [ $ID -ne 0 ]; then
    echo "Error:: Please run the script with root user."
    exit 1
else
    echo "Your are root user."
fi

yum install mysqlll -y

if [ $? -ne 0 ]; then
    echo "Installating MYSQL failed"
    exit 1
else
    echo "Installating MYSQL Successfull"
fi
