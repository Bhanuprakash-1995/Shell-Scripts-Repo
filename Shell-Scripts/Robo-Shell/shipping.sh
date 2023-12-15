#!/bin/bash

######################################################
# Author: Bhanuprakash S
# Server name: Shipping Server
# Application Name: Roboshop
# Devolepment Data: 15-12-2024
######################################################

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MYSQL_HOST=mysql.roboshopapp.website
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

dnf install maven -y

VALIDATE $? "Start MySql Repo" &>>$LOGFILE

id roboshop

if [ $? -ne 0 ]; then
    useradd roboshop
    VALIDATE $? "roboshop user creation" &>>$LOGFILE
else
    echo -e "roboshop user already exist $Y SKIPPING $N" &>>$LOGFILE
fi

VALIDATE $? "Adding Roboshop User" &>>$LOGFILE

mkdir -p /app

VALIDATE $? "Creating app directory" &>>$LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE

VALIDATE $? "Downloading the shipping application" &>>$LOGFILE

cd /app

unzip -o /tmp/shipping.zip &>>$LOGFILE

VALIDATE $? "Unzipping shipping application in app directory" &>>$LOGFILE

cd /app

mvn clean package

VALIDATE $? "Building the shipping application" &>>$LOGFILE

mv target/shipping-1.0.jar shipping.jar

VALIDATE $? "Renaming the zar file" &>>$LOGFILE

cp /home/centos/Shell-Scripts-Repo/Shell-Scripts/Robo-Shell/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE

systemctl daemon-reload

VALIDATE $? "Shipping Service Reload" &>>$LOGFILE

systemctl enable shipping

VALIDATE $? "Enable Shipping Service" &>>$LOGFILE

systemctl start shipping

VALIDATE $? "Start Shipping Service" &>>$LOGFILE

dnf install mysql -y

VALIDATE $? "Install ysql" &>>$LOGFILE

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 </app/schema/shipping.sql

VALIDATE $? "Loading the Shipping Data" &>>$LOGFILE

systemctl restart shipping

VALIDATE $? "reStart Shipping Service" &>>$LOGFILE
