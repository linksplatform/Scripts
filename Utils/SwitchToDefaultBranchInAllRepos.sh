#!/bin/bash

for subdirectory in ./*/
do
  cd $subdirectory;
  printf "Repository name: ${subdirectory}\n";
  default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p');  
  git switch $default_branch;
  cd ..;
done;
