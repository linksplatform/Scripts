#!/bin/bash

# Change these values
commit_message="Commit message";

revert() {
  printf "Repository name: ${subdirectory}\n";
  cd $subdirectory;
  commit_id=$(git log --oneline | grep -o -m 1 ".*${commit_message}.*" | perl -pe "s~(?<commit_id>\S+).+~$+{commit_id}~g");
  git revert ${commit_id};
  cd ..;
}

for subdirectory in ./*/;
do
  revert &
done;
wait;
