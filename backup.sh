#!/bin/bash
<< readme
backup with 5 days rotation
usage:
./backup <path to source> <path to backup folder>
readme


function display_usage(){
        echo "./backup <path to source> <path to backup folder>"
}

if [ $# -eq 0 ]; then
        display_usage
fi

source_dir=$1
backup_dir=$2
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')


function create_backup {
        zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}" > /dev/null

        if [ $? -eq 0 ];then
                echo "backup created successfully for ${timestamp}"
        fi
}

function perform_rotation {
        backups=($(ls -t "${backup_dir}/backup_"*.zip))
        echo "${backups[@]}"

        if [ "${#backups[@]}" -gt 5 ];then
               echo "performming rotation for 5 days"

                backups_to_remove=(${backups[@]:5})



                for backup in "${backups_to_remove[@]}";
                do
                        rm -f ${backup}
                done
        fi
}




create_backup
perform_rotation
                   
