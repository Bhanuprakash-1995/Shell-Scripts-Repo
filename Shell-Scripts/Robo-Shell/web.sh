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

# shellcheck disable=SC2129
echo "Installing the nginx" &>>"$LOGFILE"

dnf install nginx -y &>>"$LOGFILE"

VALIDATE $? "Install nginx"

# shellcheck disable=SC2129
echo "Enabling the nginx" &>>"$LOGFILE"

systemctl enable nginx &>>"$LOGFILE"

VALIDATE $? "Enable nginx"

echo "Start the nginx" &>>"$LOGFILE"

systemctl start nginx &>>"$LOGFILE"

VALIDATE $? "Start nginx"

echo "Removind all default html" &>>"$LOGFILE"

rm -rf /usr/share/nginx/html/*

VALIDATE $? "Removing  all default html"

echo "Download the frontend content" &>>"$LOGFILE"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

echo "Changing the working directory to /usr/share/nginx/html" &>>"$LOGFILE"

cd /usr/share/nginx/html || exit

echo "Unzipping the /tmp/web.zip" &>>"$LOGFILE"

unzip -o /tmp/web.zip

VALIDATE $? "Unzipping all Roboshop html file"

echo "Coping the reverse proxy file to /etc/nginx/" &>>"$LOGFILE"
cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>"$LOGFILE"

VALIDATE $? "Coping the reverse proxy configuration file"

echo "reStarting nginx server " &>>"$LOGFILE"

systemctl restart nginx &>>"$LOGFILE"

VALIDATE $? "reStart nginx server"
