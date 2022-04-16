#!/bin/bash

stashAndSwitchToDefaultBranchAndPullInAllSubdirectories(){
  cd $subdirectory;
  git stash;
  default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p');  
  git switch $default_branch;
  git pull ${remote_name} ${branch_name};
  cd ..;
}

for subdirectory in ./*/
do
  stashAndSwitchToDefaultBranchAndPullInAllSubdirectories &
done;
wait;
