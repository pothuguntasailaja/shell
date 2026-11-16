#!/bin/bash


USER_ID=$(id -u) 

if [ $USER_ID -ne 0 ]; then
   echo "run with root privileges"
fi   


dnf install nginx -y

if [ $? -ne 0 ]; then
    echo "NGINX is not INSTALLED....."
else
    echo "NGINX is INSTALLED....." 
fi    
