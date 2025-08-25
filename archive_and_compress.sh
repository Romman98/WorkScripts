#!/bin/bash

archive_directory=''
date=$(date +%Y-%m-%d)
date_2=$(date -d "3 days ago" +%Y-%m-%d)


function logger {
    text_file='path/archive_log.txt'
    echo $1 >> "$text_file"
}

logger "##### Archiving Started at $(date) #####"

files_to_be_archived=($(ls -ltr --time-style=long-iso "$archive_directory"* | grep "$date_2" | awk '{print $8}' | grep .ACT))

logger "Archived files are:"
for file in "${files_to_be_archived[@]}"; do
    logger " - $file" 
done
tar -cvzf "$archive_directory/ACK_$date_2.tar.gz" ${files_to_be_archived[@]}


rm -f ${files_to_be_archived[@]}

exit_code=$?

if [ $exit_code -eq 0 ];
then logger "Archiving done successfully. Files of date $date are now archived in ACK_`date +%Y%m%d.tar.gz` "
else
           logger "An error occured during the archive."
fi
