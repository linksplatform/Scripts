#!/bin/bash

# Change these values
files_to_stage="."
remote_name="origin";
branch="main";
commit_message="Message";

commit_and_push() {
  cd $subdirectory;
  git add ${files_to_stage};
  git commit -m "${commit_message}";
  git push ${remote_name} ${branch};
  cd ..;
}

for subdirectory in ./*/;
do
  commit_and_push &
done;
wait;
