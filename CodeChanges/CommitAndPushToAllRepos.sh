#!/bin/bash

# Make sure you are in the default branch
default_branch=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p');for subdirectory in ./*/; do printf "Repository name: ${subdirectory}"; cd $subdirectory; git commit -m "Message"; git push origin $default_branch; cd ..; done;
