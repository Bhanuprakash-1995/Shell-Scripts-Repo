#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOG_PATH="/tmp/$0-$TIMESTAMP.log"

echo "Script started executing at $TIMESTAMP" &>>LOG_PATH

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$R Error$N:: $2 Installating failed"
        exit 1
    else
        echo -e "$Y Installating $N $2 $G Successfull $N"
    fi
}

if [ $ID -ne 0 ]; then
    echo -e "$R Error $N:: Please run the script with root user."
    exit 1
else
    echo -e "$G Your are root user. $N"
fi

yum install mysql -y &>>LOG_PATH

VALIDATE $? "MySql"

yum install git -y &>>LOG_PATH

VALIDATE $? "Git"
