#!/bin/bash

######################################################
# Author: Bhanuprakash S
# Server name: MySql Server
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

dnf module disable mysql -y

VALIDATE $? "Disabling current mysql version" &>>$LOGFILE

cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/mysql.repo /etc/yum.repos.d/mysql.repo

VALIDATE $? "Copied MySql Repo" &>>$LOGFILE

dnf install mysql-community-server -y

VALIDATE $? "Install MySql Repo" &>>$LOGFILE

systemctl enable mysqld

VALIDATE $? "Enable MySql Service" &>>$LOGFILE

systemctl start mysqld

VALIDATE $? "Start MySql Service" &>>$LOGFILE

mysql_secure_installation --set-root-pass RoboShop@1

VALIDATE $? "Default user and password setup" &>>$LOGFILE
