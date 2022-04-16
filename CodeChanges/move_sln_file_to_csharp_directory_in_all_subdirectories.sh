#!/bin/bash

moveSlnToCsharpDirectoryInAllSubdirectories() {
	cd $subdirectory;
	mv "Platform.${repositoryName}.sln" "csharp/";
	cd ..;
}

for subdirectory in ./*/;
do
  moveSlnToCsharpDirectoryInAllSubdirectories &
done;
wait;
