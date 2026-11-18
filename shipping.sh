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

dnf install maven -y  &>>$LOG_FILE
VALIDATE $? "INSTALL MAVEN"


id roboshop
if [ $? -ne 0 ]; then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop  &>>$LOG_FILE
VALIDATE $? "Creating System User"
else
    echo -e "roboshop user already exists.... $Y SKIPPING $N"
fi

mkdir -p /app   &>>$LOG_FILE
VALIDATE $? "CREATE APP DIR"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip   &>>$LOG_FILE
VALIDATE $? "DOWNLOAD THE CODE"

cd /app 
VALIDATE $? "CHANGE DIR"

rm -rf /app/*  &>>$LOG_FILE
VALIDATE $? "REMOVE OLD CODE"

unzip /tmp/shipping.zip  &>>$LOG_FILE
VALIDATE $? "DOWNLOAD THE CODE IN TMP DIR"

cd /app 
VALIDATE $? "CHANGE APP DIR"

mvn clean package   &>>$LOG_FILE
VALIDATE $? "BUILDING SHIPPING APPLICATION"

mv target/shipping-1.0.jar shipping.jar   &>>$LOG_FILE
VALIDATE $? "RENAMING SHIPPING "


cp $SCRIPT_DIR/shipping.service  /etc/systemd/system/shipping.service
VALIDATE $? "COPYING THE SERVICES"

systemctl daemon-reload  &>>$LOG_FILE
VALIDATE $? "DAEMON RELOAD"

systemctl enable shipping   &>>$LOG_FILE
VALIDATE $? "ENABLE SHIPPING"

systemctl start shipping
VALIDATE $? "START SHIPPING"

dnf install mysql -y  &>>$LOG_FILE
VALIDATE $? "INSTALL MYSQL"


mysql -h mysql.daws86s.de -uroot -pRoboshop@! -e  'use mysql' &>>$LOG_FILE
if [ $? -ne 0 ]; then
    mysql -h mysql.daws86s.de -uroot -pRoboshop@! < /app/db/schema.sql &>>$LOG_FILE
    mysql -h mysql.daws86s.de -uroot -pRoboshop@! < /app/db/app-user.sql  &>>$LOG_FILE
    mysql -h mysql.daws86s.de -uroot -pRoboshop@! < /app/db/master-data.sql &>>$LOG_FILE
else
    echo -e "Shipping DB already exists.... $Y SKIPPING $N"
fi



systemctl restart shipping
VALIDATE $? "INSTALL MAVEN"