#!/bin/bash

for subdirectory in ./*/
do
  default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p');
  printf "Repository name: ${subdirectory}";
  cd $subdirectory;
  git switch $default_branch;
  cd ..;
done;
