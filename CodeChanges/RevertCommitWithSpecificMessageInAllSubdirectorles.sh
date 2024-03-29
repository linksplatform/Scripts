#!/bin/bash

# Change these values
commit_message="Commit message";

revert() {
  cd $subdirectory;
  commit_id=$(git log --oneline | grep -o -m 1 ".*${commit_message}.*" | perl -pe "s~(?<commit_id>\S+).+~$+{commit_id}~g");
  [[ ${commit_id} != "" ]] && git revert --no-edit "${commit_id}";
  cd ..;
}

for subdirectory in ./*/;
do
  revert &
done;
wait;
