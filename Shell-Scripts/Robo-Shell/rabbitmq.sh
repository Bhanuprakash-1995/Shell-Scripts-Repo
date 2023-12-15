#!/bin/bash

######################################################
# Author: Bhanuprakash S
# Server name: Rabbitmq Server
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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>"$LOGFILE"

VALIDATE $? "Configure YUM Repo"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>"$LOGFILE"

VALIDATE $? "Configure YUM Repos for RabbitMQ" &>>"$LOGFILE"

dnf install rabbitmq-server -y

VALIDATE $? "Installing RabbitMQ" &>>"$LOGFILE"

systemctl enable rabbitmq-server

VALIDATE $? "Enabling RabbitMQ" &>>"$LOGFILE"

systemctl start rabbitmq-server

VALIDATE $? "Start RabbitMQ" &>>"$LOGFILE"

rabbitmqctl add_user roboshop roboshop123

VALIDATE $? "Creating User & Password for RabbitMQ" &>>"$LOGFILE"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

VALIDATE $? "Granting permission to roboshop user" &>>"$LOGFILE"
