#!/bin/bash

######################################################
# Author: Bhanuprakash S
# Server name: MongoDB Server
# Application Name: Roboshop
######################################################

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#LOG_PATH="/tmp/$0-$TIMESTAMP.log"
#C:\Users\Bhanu Prakash\OneDrive\Documents\My-Reops\Shell-Scripts\Robo-Shell\mongo.repo
echo "Script started executing at $TIMESTAMP" &>>"/tmp/$0-$TIMESTAMP.log"

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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>>"/tmp/$0-$TIMESTAMP.log"

VALIDATE $? "Copied MongoDB Repo"

echo "Installing MongoDB"

dnf install mongodb-org -y &>>"/tmp/$0-$TIMESTAMP.log"

VALIDATE $? "Installing MongoDB"

echo "Enabling the mongod"

systemctl enable mongod &>>"/tmp/$0-$TIMESTAMP.log"

VALIDATE $? "Enabling MongoDB"

echo "Start the mongod service"

systemctl start mongod &>>"/tmp/$0-$TIMESTAMP.log"

VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>"/tmp/$0-$TIMESTAMP.log"

VALIDATE $? "Remote access to MongoDB"

echo "reStart the mongod"

systemctl restart mongod &>>"/tmp/$0-$TIMESTAMP.log"

VALIDATE $? "Restarting MongoDB"
