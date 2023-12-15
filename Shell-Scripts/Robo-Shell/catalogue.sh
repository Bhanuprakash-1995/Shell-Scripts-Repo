#!/bin/bash

######################################################
# Author: Bhanuprakash S
# Server name: Catalogue Server
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

echo "Script started executing at $TIMESTAMP" &>>$LOGFILE

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

dnf module disable nodejs -y

VALIDATE $? "Disabling current NodeJS" &>>$LOGFILE

dnf module enable nodejs:18 -y

VALIDATE $? "Enabling NodeJS:18" &>>$LOGFILE

dnf install nodejs -y

VALIDATE $? "Installing NodeJS:18" &>>$LOGFILE

id roboshop

if [ $? -ne 0 ]; then
    useradd roboshop
    VALIDATE $? "roboshop user creation" &>>$LOGFILE
else
    echo -e "roboshop user already exist $Y SKIPPING $N" &>>$LOGFILE
fi

mkdir -p /app

VALIDATE $? "creating app directory" &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "Downloading catalogue application" &>>$LOGFILE

cd /app

unzip -o /tmp/catalogue.zip

VALIDATE $? "unzipping catalogue" &>>$LOGFILE

npm install

VALIDATE $? "Installing dependencies" &>>$LOGFILE

cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "Copying catalogue service file" &>>$LOGFILE

systemctl daemon-reload

VALIDATE $? "catalogue daemon reload" &>>$LOGFILE

systemctl enable catalogue

VALIDATE $? "Enable catalogue" &>>$LOGFILE

systemctl start catalogue

VALIDATE $? "Starting catalogue" &>>$LOGFILE

cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mongodb repo" &>>$LOGFILE

dnf install mongodb-org-shell -y

VALIDATE $? "Installing MongoDB client" &>>$LOGFILE

mongo --host $MONGDB_HOST </app/schema/catalogue.js

VALIDATE $? "Loading catalouge data into MongoDB" &>>$LOGFILE
