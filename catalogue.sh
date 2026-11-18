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
MONGODB_HOST=mongodb.daws86s.de


if [ $USER_ID -ne 0 ]; then
   echo "run with root privileges"
   exit 1
else
      echo "running with root privileges"
fi   


VALIDATE (){
if [ $1 -ne 0 ]; then
    echo -e "$2 is $R FAILURE...... $N"
    exit 1
else
    echo -e "$2 is  $G SUCCESS..... $N" 
fi    
}

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "DISABLE NODEJS"

dnf module enable nodejs:20 -y  &>>$LOG_FILE
VALIDATE $? "DISABLE NODEJS:20"

dnf install nodejs -y  &>>$LOG_FILE
VALIDATE $? "INSTALL NODEJS"

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
VALIDATE $? "Creating System User"
else
    echo -e "roboshop user already exists.... $Y SKIPPING $N"
fi


mkdir -p /app   &>>$LOG_FILE
VALIDATE $? "CREATING DIRECTORY"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip   &>>$LOG_FILE
VALIDATE $? "DOWNLOADING THE CODE"

cd /app   &>>$LOG_FILE
VALIDATE $? "CHANGE APP DIR"

rm -rf /app/* &>>$LOG_FILE
VALIDATE $? "Removing Old Application Content"

unzip /tmp/catalogue.zip  &>>$LOG_FILE
VALIDATE $? "DOWNLOADING THE CODE IN TEMP DIR"

cd /app   &>>$LOG_FILE
VALIDATE $? "CHANGE APP DIR"

npm install   &>>$LOG_FILE
VALIDATE $? "INSTALL DEPENDENCIES"

cp $SCRIPT_DIR/catalogue.service  /etc/systemd/system/catalogue.service   &>>$LOG_FILE
VALIDATE $? "COPYING THE SERVICES"

systemctl daemon-reload   &>>$LOG_FILE
VALIDATE $? "DAEMON RELOAD"

systemctl enable catalogue   &>>$LOG_FILE
VALIDATE $? "ENABLE CATALOGUE"

systemctl start catalogue   &>>$LOG_FILE
VALIDATE $? "START CATALOGUE"

cp $SCRIPT_DIR/mongo.repo  /etc/yum.repos.d/mongo.repo   &>>$LOG_FILE
VALIDATE $? "COPYING THE REPOS"


dnf install mongodb-mongosh -y   &>>$LOG_FILE
VALIDATE $? "INSTALL MONGODB"


INDEX=$(mongosh $MONGODB_HOST --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -lt 0 ]; then
     mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
     VALIDATE $? "Loading Catalogue Products"
else
    echo -e "Catalogue Products already Loaded.... $Y SKIPPING $N"
fi


systemctl restart catalogue &>>$LOG_FILE
VALIDATE $? "Restarting Catalogue Service"