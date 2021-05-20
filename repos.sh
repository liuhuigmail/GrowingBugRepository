#!/bin/bash

cd `dirname $0`
path=$PWD
work_dir="$path/project_repos"
cd $work_dir
cat ../project_information.txt | while read line
do
    # read project information
    read -ra strarr <<<"$line"
    project_link=${strarr[0]} 
    project_name=${strarr[1]} 
    new_name=$(echo $project_name | sed -e 's/\r//g')
    echo "PROJECT_LINK: $project_link"
    echo "PROJECT_NAME: $project_name"
    
    #echo "WORK_DIR: $work_dir"
            
    # clone projects
    git clone $project_link
    cd $new_name
    mv .git $new_name.git
    mv $new_name.git ../
    cd ..
    rm -rf $new_name
done
