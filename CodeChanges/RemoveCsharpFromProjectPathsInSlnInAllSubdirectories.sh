#!/bin/bash

removeCsharpFromProjectPathsInSlnInAllSubdirectories() {
	cd $subdirectory
	repositoryName=$(basename "$subdirectory")
	perl -0777pi -e "s~csharp\\\\~~g" csharp/Platform.${repositoryName}.sln
	cd ..
}


for subdirectory in ./*/;
do
  removeCsharpFromProjectPathsInSlnInAllSubdirectories &
done;
wait;
