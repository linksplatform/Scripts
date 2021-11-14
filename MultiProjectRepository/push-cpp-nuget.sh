#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

sudo apt-get install nuget

CPP_PACKAGE_NUSPEC_PATH=$(<CPP_PACKAGE_NUSPEC_PATH.txt)
CPP_PACKAGE_NUSPEC_DIRECTORY=$(dirname "$CPP_PACKAGE_NUSPEC_PATH")
CPP_PACKAGE_VERSION=$(<CPP_PACKAGE_VERSION.txt)

# Ensure NuGet package does not exist
NuGetPackageUrl="https://globalcdn.nuget.org/packages/Platform.$REPOSITORY_NAME.TemplateLibrary.$CPP_PACKAGE_VERSION.nupkg"
NuGetPackageUrl=$(echo "$NuGetPackageUrl" | tr '[:upper:]' '[:lower:]')
NuGetPageStatus="$(curl -Is "$NuGetPackageUrl" | head -1)"
StatusContents=( $NuGetPageStatus )
if [ "${StatusContents[1]}" == "200" ]; then
  echo "NuGet with current version is already pushed."
  exit 0
fi

# Download icon.png for the package
wget -O "$CPP_PACKAGE_NUSPEC_DIRECTORY/icon.png" https://raw.githubusercontent.com/linksplatform/Documentation/18469f4d033ee9a5b7b84caab9c585acab2ac519/doc/Avatar-rainbow-icon-64x64.png

# Download TemplateLibrary.targets for the package
wget -O "$CPP_PACKAGE_NUSPEC_DIRECTORY/Platform.$REPOSITORY_NAME.TemplateLibrary.targets" https://raw.githubusercontent.com/linksplatform/Files/ed0dc702f52d56d80ea2f19c93df5cf2fdcbccbf/TemplateLibrary.targets

# Update .nuspec file
files=$(find $(dirname $CPP_PACKAGE_NUSPEC_PATH) | grep "\.h" | cut -c $(( $(echo $(dirname $CPP_PACKAGE_NUSPEC_PATH) | wc -m) + 1))-)
filename="$CPP_PACKAGE_NUSPEC_PATH"
file=() #Initialize array
while IFS= read -r line #Read file to string "targets" and append to array.
do 
	file+=("${line}")
		if [[ $line == *"targets"* ]]
		then
		break
		fi
done < "$filename" #Read .nuspec file
IFS=$'\n' #Set Separator.
for FILE in $files #Get all files on directory.
do
	file+=("    <file src=\"$FILE\" target=\"lib\\native\\include\\$FILE\" />") #Append new files to array.
done
file+=("  </files>") #Append end for tag files.
file+=("</package>") #Append end for tag package.
printf '%s\n' "${file[@]}" > "$filename" #Write array by line to .nuspec file.

# Pack NuGet package by .nuspec file
nuget pack "$CPP_PACKAGE_NUSPEC_PATH"

# Push NuGet package
nuget push ./**/*.nupkg -NoSymbols -Source https://api.nuget.org/v3/index.json -ApiKey "${NUGETTOKEN}" 

# Clean up
find . -type f -name '*.nupkg' -delete
