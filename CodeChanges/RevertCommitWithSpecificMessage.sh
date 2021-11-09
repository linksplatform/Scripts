#!/bin/bash
for subdirectory in ./*/; do printf "Repository name: ${subdirectory}"; cd $subdirectory; commit_id=$(git log --oneline | grep -o -m 1 'Message' | perl -pe 's~(\S*).+~$1~g'); git revert ${commit_id}; cd ..; done;
