#!/bin/bash

default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p');
for subdirectory in ./*/
do
  printf "Repository name: ${subdirectory}";
  cd $subdirectory;
  git switch $default_branch;
  cd ..;
done;
