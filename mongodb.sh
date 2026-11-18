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


cp mongo.repo  /etc/yum.repos.d/mongo.repo
VALIDATE $? "adding the repos"


dnf install mongodb-org -y  &>>$LOG_FILE
VALIDATE $? "INSTALL MONGODB"

systemctl enable mongod
VALIDATE $? "ENABLE MONGODB"

systemctl start mongod 
VALIDATE $? "START MONGODB"

sed -i  's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing Remote Connections to Mongodb"

systemctl restart mongod
VALIDATE $? 'Restart Mongodb'