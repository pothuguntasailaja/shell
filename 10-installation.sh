#!/bin/bash


USER_ID=$(id -u) 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p LOG_FOLDER

LOG_FOLDER="/var/log/shell"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=$LOG_FOLDER/$SCRIPT_NAME

if [ $USER_ID -ne 0 ]; then
   echo "run with root privileges"
fi   


VALIDATE (){
if [ $1 -ne 0 ]; then
    echo -e "$2 is $R FAILURE...... $N"
else
    echo -e "$2 is  $G SUCCESS..... $N" 
fi    
}


dnf list installed nginx &>>$LOG_FILE
if  [ $? -ne 0 ]; then
   dnf install nginx -y
   VALIDATE $? "NGINX" 
else
    echo -e "NGINX already installed $Y SKIPPING.... $N"   
fi   

dnf list installed mysql &>>$LOG_FILE
if [ $? -ne 0 ]; then
   dnf install mysql -y 
   VALIDATE $? "MYSQL"
else
   echo -e " MYSQL already installed $Y SKIPPING.... $N"   
fi


dnf list installed python3 &>>$LOG_FILE
if [ $? -ne 0 ]; then
   dnf install python3 -y 
   VALIDATE $? "PYTHON3" 
else    
    echo -e "PYTHON already installed $Y SKIPPING.... $N"   
fi