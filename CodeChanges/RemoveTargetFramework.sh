#!/bin/bash

# Assign your framefork to this variable
framework_regular_expression="netstandard2\.1" 

find . -type f -name "*.csproj" -exec perl -0777pi -e "s~(?<before><TargetFrameworks>.*?)${framework_regular_expression};(?<after>.*?<\/TargetFrameworks>)~$+{before}$+{after}~" {} \;
