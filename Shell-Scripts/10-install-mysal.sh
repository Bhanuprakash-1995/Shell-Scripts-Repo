#!/bin/bash

ID=$(id -u)

if [ $ID -ne 0 ]; then
    echo "Error:: Please run the script with root user."
else
    echo "Your are root user."
fi

yum install mysql -y

echo "After fail"
