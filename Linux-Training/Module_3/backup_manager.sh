#!/bin/bash

if [ "$#" -ne 3 ];
then
echo "Insufficent arguments"
exit 1
fi

SOURCE_DIR="$1"
DESTINATION_DIR="$2"
FILE_EXTENSION="$3"

shopt -s nullglob

files_array=("$SOURCE_DIR"/*"$FILE_EXTENSION")

if [ ${#files_array[@]} -eq 0 ];then
echo "No file matching the $FILE_EXTENSION could be found in the $SOURCE_DIR" 
exit 1
fi

for file in "${files_array[@]}";do
file_size=$(stat -c%s "$file")
echo "File Name: $file   File Size: $file_size bytes"
done

if [ ! -d "$DESTINATION_DIR" ]
then
mkdir -p "$DESTINATION_DIR" || { echo "Failed to create a directory";exit 1; }
fi

export BACKUP_COUNT=0
TOTAL_SIZE=0

for file in "${files_array[@]}";do
fname=$(basename "$file")
des_path="$DESTINATION_DIR/$fname"

if [[ ! -f "$des_path" ]] || [[  "$file" -nt "$des_path" ]];then
cp "$file" "$DESTINATION_DIR/"
BACKUP_COUNT=$((BACKUP_COUNT+1))
fsize=$(stat -c%s "$file")
TOTAL_SIZE=$((TOTAL_SIZE+ fsize))
fi
done


cat << EOF > "$DESTINATION_DIR/backup_report.log"
SUMMARY
The total number of files found is ${#files_array[@]}
The total number of files procesed is $BACKUP_COUNT
The size of the files processed is $TOTAL_SIZE 
The path of the backup directory is $DESTINATION_DIR 
EOF


echo "The processed report is saved at $DESTINATION_DIR/backup_report.log"

