#!/bin/bash

######################################################
# Author: Bhanuprakash S
# Server name: Dispatch Server
# Application Name: Roboshop
# Devolepment Data: 15-12-2024
######################################################

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

dnf install golang -y

VALIDATE $? "Installing Golang" &>>LOGFILE

id roboshop

if [ $? -ne 0 ]; then
    useradd roboshop
    VALIDATE $? "roboshop user creation" &>>$LOGFILE
else
    echo -e "roboshop user already exist $Y SKIPPING $N" &>>$LOGFILE
fi

VALIDATE $? "Create user roboshop" &>>LOGFILE

mkdir /app

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip

VALIDATE $? "Downloading dispatch applicaiton" &>>LOGFILE

cd /app

unzip /tmp/dispatch.zip

VALIDATE $? "Unzipping the dispatch applicaiton file" &>>LOGFILE

cd /app

go mod init dispatch

go get

go build

VALIDATE $? "Golang Build" &>>LOGFILE

cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/dispatch.service /etc/systemd/system/dispatch.service

systemctl daemon-reload

VALIDATE $? " Dispatch Service Daemon Reload" &>>LOGFILE

systemctl enable dispatch

VALIDATE $? "Enable Dispatch Service" &>>LOGFILE

systemctl start dispatch

VALIDATE $? "Start Dispatch Service" &>>LOGFILE
