#!/bin/bash

ID=$(id -u)

VALIDATE() {
    if [ $? -ne 0 ]; then
        echo "Installating failed"
        exit 1
    else
        echo "Installating Successfull"
    fi
}

if [ $ID -ne 0 ]; then
    echo "Error:: Please run the script with root user."
    exit 1
else
    echo "Your are root user."
fi

yum install mysql -y

VALIDATE

yum install git -y
