#!/bin/bash

use_ssh() {
  cd ${subdirectory};
  repository_name=$(printf "$subdirectory" | perl -pe 's~\./(?<repository_name>.*)\/~$+{repository_name}~g');
  git remote set-url origin git@github.com:linksplatform/${repository_name}.git;
  printf "\n${repository_name} - Done\n";
  cd ..;
}

for subdirectory in ./*/
do
  use_ssh &
done;
