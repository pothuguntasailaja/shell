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
SOURCE_DIR=$1
DEST_DIR=$2



if [ $USER_ID -ne 0 ]; then
   echo "run with root privileges"
   exit 1
else
      echo "running with root privileges"
fi   

USAGE(){
    echo  -e "$R USAGE:: sudo sh backup.sh <SOURCE_DIR> <DEST_DIR> $N"
    exit 1
}


if [ $# -lt 2 ]; then
   USAGE
fi


if [ ! -d $SOURCE_DIR  ]; then
    echo  -e "$R source $SOURCE_DIR does not exist $N"
    exit 1
fi


if [ ! -d $DEST_DIR ]; then
   echo -e "$R destination $DEST_DIR does not exist $N"
   exit 1
   fi


FILES=$(find $SOURCE_DIR -name "*.log" -type f)

if [ ! -z "${FILES}" ]; then
   echo "Files found: $FILES"
   ZIP_FILE_NAME="$DEST_DIR/app-logs.zip"
   echo "zip file name: $ZIP_FILE_NAME"
   find $SOURCE_DIR -name "*.log" -type f | zip -@ -j "$ZIP_FILE_NAME"


   if [ -f $ZIP_FILE_NAME ]
     then
    echo -e "Archeival ..... $G  SUCCESS $N"
   
   

    while IFS= read -r filepath
    do
      echo "deleting the file: $filepath"
      rm -rf $filepath
      echo "deleted the file: $filepath"
    done <<< "$FILES"

    else
       echo "Archieval .... $R FAILURE $N"
       exit 1
    fi

 else
    echo "No files to Archieve...  $Y SKIPPING $N"
fi      

   