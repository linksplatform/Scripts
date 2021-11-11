#!/bin/bash

# Change these values
remote_name="origin";
branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p');
commit_message="Message";

for subdirectory in ./*/;
do
  cd $subdirectory;
  printf "Repository name: ${subdirectory}";
  git commit -m ${commit_message};
  git push ${remote_name} ${branch};
  cd ..;
done;
