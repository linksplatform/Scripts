#!/bin/bash
find . -name *.cs -exec perl -0777pi -e 's~(/{3}.+(\r|\n|\s)+)+(private|class)~private~gm' {}  \
