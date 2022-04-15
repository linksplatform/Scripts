#!/bin/bash

moveSlnToCsharpDirectory() {
	for subdirectory in ./*/;
	do
		cd $subdirectory;
		git stash;
		git checkout main;
		git pull;
		repositoryName=$(basename "$subdirectory")
		mv "Platform.${repositoryName}.sln" "csharp/";
		git add *.sln;
		git commit -m "Move sln file to csharp"
		git push;
		cd ..;
	done;
}


for subdirectory in ./*/;
do
  moveSlnToCsharpDirectory &
done;
wait;
