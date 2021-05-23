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
    echo "PROJECT_LINK: $project_link"
    echo "PROJECT_NAME: $project_name"
    
    #echo "WORK_DIR: $work_dir"
            
    # clone projects
    git clone $project_link
    cd $project_name
    mv .git $project_name.git
    mv $project_name.git ../
    cd ..
    rm -rf $project_name
done
