#!/bin/bash

# Assign your framefork to this variable
framework_regular_expression="netstandard2\.1" 
new_framework="netstandard3.1"

find . -type f -name "*.csproj" -exec perl -0777pi -e "s~(?<before><TargetFrameworks>.*?)${framework_regular_expression};(?<after>.*?<\/TargetFrameworks>)~$+{before}${new_framework};$+{after}~" {} \;

# Remove duplicates
find . -type f -name "*.csproj" -exec perl -0777pi -e "s~(?<before><TargetFrameworks>.*?)${new_framework};(?<between>)${new_framework};(?<after>.*?<\/TargetFrameworks>)~$+{before}$+{between}${new_framework};$+{after}~" {} \;
