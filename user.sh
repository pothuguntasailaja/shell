#!/bin/bash


USER_ID=$(id -u) 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


LOG_FOLDER="/var/log/shell"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
mkdir -p $LOG_FOLDER
SCRIPT_DIR=$PWD

if [ $USER_ID -ne 0 ]; then
   echo "run with root privileges"
   else
      echo "running with root privileges"
fi   


VALIDATE (){
if [ $1 -ne 0 ]; then
    echo -e "$2 is $R FAILURE...... $N"
else
    echo -e "$2 is  $G SUCCESS..... $N" 
fi    
}


dnf module disable nodejs -y   &>>$LOG_FILE
VALIDATE $? "DISABLE NODEJS"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "ENABLE NODEJS"

dnf install nodejs -y  &>>$LOG_FILE
VALIDATE $? "INSTALL NODEJS"

useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop  &>>$LOG_FILE
VALIDATE $? "CREATE SYSTEM USER"

mkdir -p /app &>>$LOG_FILE
VALIDATE $? "CREATE APP DIR"

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip  &>>$LOG_FILE
VALIDATE $? "DOWNLOAD THE CODE"

cd /app  &>>$LOG_FILE
VALIDATE $? "CHANGE DIR"


rm -rf /app/* &>>$LOG_FILE
VALIDATE $? "REMOVE OLD CODE"

unzip /tmp/user.zip &>>$LOG_FILE
VALIDATE $? "DOWNLOAD THE CODE IN TEMP DIR"

cd /app  &>>$LOG_FILE
VALIDATE $? "DISABLE NODEJS"

npm install  &>>$LOG_FILE
VALIDATE $? "INSTALL DEPENDENCIES"


cp $SCRIPT_DIR/user.service  /etc/systemd/system/user.service
VALIDATE $? "COPYING THE SERVICES"


systemctl daemon-reload
VALIDATE $? "DAEMON RELOAD"

systemctl enable user 
VALIDATE $? "ENABLE USER"


systemctl start user
VALIDATE $? "START USER"

