#!/bin/bash

######################################################
# Author: Bhanuprakash S
# Server name: Payment Server
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

dnf install python36 gcc python3-devel -y

VALIDATE $? "Intsalling python" &>>$LOGFILE

useradd roboshop

VALIDATE $? "Creating the user" &>>$LOGFILE

mkdir /app

VALIDATE $? "Create=ing Directory app" &>>$LOGFILE

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip

VALIDATE $? "Downloading payment application" &>>$LOGFILE

cd /app

unzip /tmp/payment.zip

VALIDATE $? "Unzipping payment.zip" &>>$LOGFILE

pip3.6 install -r requirements.txt

VALIDATE $? "Installing application requirements" &>>$LOGFILE

cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/payment.service /etc/systemd/system/payment.service

VALIDATE $? "Creating payment service" &>>$LOGFILE

systemctl daemon-reload

VALIDATE $? "Reload payment service" &>>$LOGFILE

systemctl enable payment

VALIDATE $? "Enable payment service" &>>$LOGFILE

systemctl start payment

VALIDATE $? "Start payment service" &>>$LOGFILE
