#!/bin/bash

######################################################
# Author: Bhanuprakash S
# Server name: Cart Server
# Application Name: Roboshop
# Devolepment Data: 14-12-2024
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

dnf module disable nodejs -y &>>$LOGFILE

VALIDATE $? "Disabling current NodeJS"

dnf module enable nodejs:18 -y &>>$LOGFILE

VALIDATE $? "Enabling NodeJS:18"

dnf install nodejs -y &>>$LOGFILE

VALIDATE $? "Installing NodeJS:18"

id roboshop

if [ $? -ne 0 ]; then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app

VALIDATE $? "creating app directory"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE

VALIDATE $? "Downloading cart application"

cd /app

unzip -o /tmp/cart.zip

VALIDATE $? "unzipping cart" &>>$LOGFILE

npm install

VALIDATE $? "Installing Dependices" &>>$LOGFILE

cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/cart.service /etc/systemd/system/cart.service

systemctl daemon-reload

VALIDATE $? "Daemon-reload cart Service" &>>$LOGFILE

systemctl enable cart

VALIDATE $? "Enable cart Service" &>>$LOGFILE

systemctl start cart

VALIDATE $? "Start cart Service" &>>$LOGFILE
