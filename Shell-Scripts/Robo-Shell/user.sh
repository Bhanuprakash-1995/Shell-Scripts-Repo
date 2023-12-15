#!/bin/bash

######################################################
# Author: Bhanuprakash S
# Server name: User Server
# Application Name: Roboshop
# Devolepment Data: 14-12-2024
######################################################

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

MONGDB_HOST=mongodb.roboshopapp.website

LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started executing at $TIMESTAMP" &>>"$LOGFILE"

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

dnf module disable nodejs -y &>>"$LOGFILE"

VALIDATE $? "Disabling current NodeJS"

dnf module enable nodejs:18 -y &>>"$LOGFILE"

VALIDATE $? "Enabling NodeJS:18"

dnf install nodejs -y &>>"$LOGFILE"

VALIDATE $? "Installing NodeJS:18"

id roboshop

# shellcheck disable=SC2181
if [ $? -ne 0 ]; then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app

VALIDATE $? "creating app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

VALIDATE $? "Downloading user application"

cd /app || exit

unzip -o /tmp/user.zip &>>"$LOGFILE"

VALIDATE $? "unzipping user"

npm install &>>"$LOGFILE"

VALIDATE $? "Installing dependencies"

cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/user.service /etc/systemd/system/user.service &>>"$LOGFILE"

VALIDATE $? "Copying user service file"

systemctl daemon-reload &>>"$LOGFILE"

VALIDATE $? "user daemon reload"

systemctl enable user &>>"$LOGFILE"

VALIDATE $? "Enable user"

systemctl start user &>>"$LOGFILE"

VALIDATE $? "Starting user"

cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mongodb repo"

dnf install mongodb-org-shell -y &>>"$LOGFILE"

VALIDATE $? "Installing MongoDB client"

mongo --host $MONGDB_HOST </app/schema/user.js

VALIDATE $? "Loading user data into MongoDB"