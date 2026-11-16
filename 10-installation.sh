#!/bin/bash


USER_ID=$(id -u) 

if [ $USER_ID -ne 0 ]; then
   echo "run with root privileges"
fi   
