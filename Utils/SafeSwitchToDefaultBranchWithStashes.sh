#!/bin/bash

switch(){
  cd $subdirectory;
  printf "Repository name: ${subdirectory}\n";
  default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p'); 
  git stash; 
  git switch $default_branch;
  cd ..;
}

for subdirectory in ./*/
do
  switch &
done;
wait;
