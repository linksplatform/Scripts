#!/bin/bash

if [[ "$1" = "-h" ]] # Help Documentation.
then 
	echo "This is script update old .nuspec file."
	echo ""
	echo "Usage:"
	echo "UpdateNuspec.sh <Path to files for update>"
	echo ""
	echo "EXAMPLE:"
	echo "UpdateNuspec.sh"
	#echo "	OR"
	#echo "UpdateNuspec.sh dir/files"
	
	exit 0#Success code.
fi

files=$(find *.h)
filename=$(find *.nuspec)
file=() #Initialize array
while IFS= read -r line #Read file to string "targets" and append to array.
do 
	file+=("${line}")
		if [[ $line == *"targets"* ]]
		then
		break
		fi
done < "$filename" #Read .nuspec file
IFS=$'\n' #Separator is standard.
for FILE in $files #Get all files on directory.
do
	file+=("    <file src=\"$FILE\" target=\"lib\\native\\include\\$FILE\" />") #Append new files to array.
done
file+=("  </files>") #Append end for tag files.
file+=("</package>") #Append end for tag package.
printf '%s\n' "${file[@]}" > "$filename" #Write array by line to .nuspec file.
exit 0 #Success code.
