#!/bin/bash

if [[ "$#" == 0 ]]
then
echo "RemoveXMLDocumentation.sh <file>"
exit 0
fi

IFS=$'\n'
file=("$(cat $1 | grep -v "///")")
printf '%s\n' $file > $1
