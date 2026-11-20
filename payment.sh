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


dnf install python3 gcc python3-devel -y  &>>$LOG_FILE
VALIDATE $? "INSTALL PYTHON3"


id roboshop &>>$LOG_FILE

if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop   &>>$LOG_FILE
   VALIDATE $? "CREATE SYSTEM USER"
else
    echo -e "roboshop user already exists.... $Y SKIPPING $N"
fi

mkdir -p  /app   &>>$LOG_FILE
VALIDATE $? "CREATE APP DIR"

curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip    &>>$LOG_FILE
VALIDATE $? "DOWNLOAD THE CODE"

cd /app 
VALIDATE $? "CHANGE APP DIR"

unzip /tmp/payment.zip   &>>$LOG_FILE
VALIDATE $? "DOWNLOAD THE CODE IN TEMP DIR"


cd /app 
VALIDATE $? "CHANGE APP DIR"

pip3 install -r requirements.txt   &>>$LOG_FILE
VALIDATE $? "INSTALL PIP3"

cp $SCRIPT_DIR/payment.service /etc/systemd/system/payment.service
VALIDATE $? "COPYING THE SERVICES"

systemctl daemon-reload   &>>$LOG_FILE
VALIDATE $? "DAEMON RELOAD"

systemctl enable payment   &>>$LOG_FILE
VALIDATE $? "ENABLE PAYMENT"

systemctl start payment  &>>$LOG_FILE
VALIDATE $? "START PAYMENT"
