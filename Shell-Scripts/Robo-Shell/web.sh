#!/bin/bash

######################################################
# Author: Bhanuprakash S
# Server name: Web Server
# Application Name: Roboshop
# Devolepment Data: 14-12-2024
######################################################

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
#MONGDB_HOST=mongodb.roboshopapp.website
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

dnf install nginx -y

VALIDATE $? "Install nginx" &>>$LOGFILE

systemctl enable nginx

VALIDATE $? "Enable nginx" &>>$LOGFILE

systemctl start nginx

VALIDATE $? "Start nginx" &>>$LOGFILE

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $? "Removing  all default html" &>>$LOGFILE

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

cd /usr/share/nginx/html

unzip -o /tmp/web.zip &>>$LOGFILE

VALIDATE $? "Unzipping all Roboshop html file" &>>$LOGFILE

cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE

VALIDATE $? "Coping the reverse proxy configuration file" &>>$LOGFILE

systemctl restart nginx

VALIDATE $? "reStart nginx server" &>>$LOGFILE
