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

echo "Script started executing at $TIMESTAMP" &>>"$LOGPATH"

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

cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>"$LOGPATH"

VALIDATE $? "Copied MongoDB Repo"

dnf install mongodb-org -y &>>"$LOGPATH"

VALIDATE $? "Installing MongoDB" &>>"$LOGPATH"

systemctl enable mongod &>>"/tmp/$0-$TIMESTAMP.log"

VALIDATE $? "Enabling MongoDB" &>>"$LOGPATH"

systemctl start mongod &>>"/tmp/$0-$TIMESTAMP.log"

VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>"/tmp/$0-$TIMESTAMP.log"

VALIDATE $? "Remote access to MongoDB" &>>"$LOGPATH"

systemctl restart mongod &>>"/tmp/$0-$TIMESTAMP.log"

VALIDATE $? "Restarting MongoDB" &>>"$LOGPATH"
