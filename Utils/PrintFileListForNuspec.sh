#!/bin/bash

#ATTENTION!!
#USE IN DIRECTORY WITH FILES .h
files=$(ls *.h)
for FILE in $files; do echo "<file src=\"$FILE\" target=\"lib\\native\\include\\$FILE\" />"; done
