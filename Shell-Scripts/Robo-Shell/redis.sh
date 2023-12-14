#!/bin/bash

######################################################
# Author: Bhanuprakash S
# Server name: Redis Server
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

echo "Installing the redis from Repo file"

# shellcheck disable=SC2129
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>"$LOGFILE"

VALIDATE $? "Redis Repo Installation" &>>"$LOGFILE"

echo "Enabling the module redis:remi-6.2 from package streams" &>>"$LOGFILE"

dnf module enable redis:remi-6.2 -y &>>"$LOGFILE"

VALIDATE $? "Enabling the redis:remi-6.2" &>>"$LOGFILE"

echo "Installing the redis" &>>"$LOGFILE"

dnf install redis -y &>>"$LOGFILE"

VALIDATE $? "Redis Installation" >>"$LOGFILE"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf >>"$LOGFILE"

echo "Enabling the redis"

systemctl enable redis

VALIDATE $? "Redis Enable" >>"$LOGFILE"

echo "Start the redis"

systemctl start redis

VALIDATE $? "Start Redis" >>"$LOGFILE"
