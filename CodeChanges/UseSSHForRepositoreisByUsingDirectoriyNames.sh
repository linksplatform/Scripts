#!/bin/bash
for subdirectory in ./*/; do cd ${subdirectory}; repository_name=$(printf "$subdirectory" | perl -pe 's~\./(?<repository_name>.*)\/~$+{repository_name}~g'); printf "\n${repository_name}\n"; git remote remove origin; git remote add origin git@github.com:linksplatform/${repository_name}.git; cd ..; done;
