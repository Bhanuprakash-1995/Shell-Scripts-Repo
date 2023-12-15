#!/bin/bash

######################################################
# Author: Bhanuprakash S
# Server name: MongoDB Server
# Application Name: Roboshop
# Devolepment Data: 14-12-2024
######################################################

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGPATH="/tmp/$0-$TIMESTAMP.log"

echo "Script started executing at $TIMESTAMP" &>>$LOGPATH

if [ "$ID" -ne 0 ]; then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
else
    echo -e "$Y Your are root user. $N"
fi

VALIDATE() {
    if [ "$1" -ne 0 ]; then
        echo -e "$R Error$N:: $2 Installating failed"
    else
        echo -e "$Y Installating $N $2 $G Successfull $N"
    fi
}

cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGPATH

VALIDATE $? "Copied MongoDB Repo" &>>$LOGPATH

dnf install mongodb-org -y

VALIDATE $? "Installing MongoDB" &>>$LOGPATH

systemctl enable mongod

VALIDATE $? "Enabling MongoDB" &>>$LOGPATH

systemctl start mongod

VALIDATE $? "Starting MongoDB" &>>$LOGPATH

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

VALIDATE $? "Remote access to MongoDB" &>>$LOGPATH

systemctl restart mongod

VALIDATE $? "Restarting MongoDB" &>>$LOGPATH
