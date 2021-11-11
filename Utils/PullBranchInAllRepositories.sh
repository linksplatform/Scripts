#!/bin/bash

# Change these values
remote_name="origin";
branch_name="branch_name";

pull() {
  cd $subdirectory;
  printf "Repository name: ${subdirectory}";
  git pull ${remote_name} ${branch_name};
  cd ..;
}

for subdirectory in ./*/
do
  pull &
done;
wait;
