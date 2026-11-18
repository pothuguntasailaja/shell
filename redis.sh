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


dnf module disable redis -y  &>>$LOG_FILE
VALIDATE $? "DISABLE REDIS"

dnf module enable redis:7 -y  &>>$LOG_FILE
VALIDATE $? "ENABLE REDIS"


dnf install redis -y  &>>$LOG_FILE
VALIDATE $? "INSTALL REDIS"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "ALLOWING REMOTE CONNECTIONS"

systemctl enable redis 
VALIDATE $? "ENABLE REDIS"

systemctl start redis 
VALIDATE $? "START REDIS"