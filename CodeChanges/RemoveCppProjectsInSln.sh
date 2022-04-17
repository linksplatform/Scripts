#!/bin/bash

find . -type f -name "*.sln" -exec perl -0777pi -e "s~^Project.*cpp.*$\s~~gm" {} \;
