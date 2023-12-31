#!/bin/bash

ID=$(id -u)

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo "Error:: $2 Installating failed"
        exit 1
    else
        echo "Installating $2 Successfull"
    fi
    echo "$3"
}

if [ $ID -ne 0 ]; then
    echo "Error:: Please run the script with root user."
    exit 1
else
    echo "Your are root user."
fi

yum install mysql -y

VALIDATE $? "MySql"

yum install git -y

VALIDATE $? "Git" "GIt Installed Completly"
