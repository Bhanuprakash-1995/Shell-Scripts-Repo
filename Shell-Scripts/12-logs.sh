#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F_%H)
LOGFILE="/tmp/$0_$TIMESTAMP.log"
echo "Script Name: $0"

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo "Error:: $2 Installating failed"
        exit 1
    else
        echo "Installating $2 Successfull"
    fi
}

if [ $ID -ne 0 ]; then
    echo "Error:: Please run the script with root user."
    exit 1
else
    echo "Your are root user."
fi

yum install mysql -y &>>LOGFILE

VALIDATE $? "MySql"

yum install git -y &>>LOGFILE

VALIDATE $? "Git"
