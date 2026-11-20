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


SOURCE_DIR=/home/ec2-user/app-logs

if [ ! -d $SOURCE_DIR ]; then
   echo "$SOURCE_DIR IS NOT THERE SO ERROR"
    exit 1
fi


files_to_delete=$(find . -name "*.log" -type f)




while IFS= read -r filepath
 do
    echo "deleting the file: $filepath"
    rm -rf $filepath
    echo "deleted the file: $filepath"
done <<< "$files_to_delete"
