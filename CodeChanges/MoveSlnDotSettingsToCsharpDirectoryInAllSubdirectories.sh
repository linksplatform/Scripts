#!/bin/bash

moveSlnDotSettingsToCsharpDirectoryInAllSubdirectories() {
	cd $subdirectory;
	repositoryName=$(basename "$subdirectory")
	mv "Platform.${repositoryName}.sln.DotSettings" "csharp/";
	cd ..;
}


for subdirectory in ./*/;
do
  moveSlnDotSettingsToCsharpDirectoryInAllSubdirectories &
done;
wait;
