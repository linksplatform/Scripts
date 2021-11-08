#!/bin/bash

# Make sure you are in the default branch
for subdirectory in ./*/; do cd $subdirectory; default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p');printf "Repository name: ${subdirectory}"; git commit -m "Message"; git push origin $default_branch; cd ..; done;
