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


for package in $@
do
  echo "print $package"
dnf list installed $package &>>$LOG_FILE
if  [ $? -ne 0 ]; then
   dnf install $package -y &>>$LOG_FILE
   VALIDATE $? "$package" 
else
    echo -e "$package already installed $Y SKIPPING.... $N"   
fi   
done