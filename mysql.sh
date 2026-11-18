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


dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "INSTALL MYSQL"

systemctl enable mysqld
VALIDATE $? "ENABLE MYSQL"

systemctl start mysqld  
VALIDATE $? "START MYSQL"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
VALIDATE $? "SETTING THE USER AND PASSWORD"
