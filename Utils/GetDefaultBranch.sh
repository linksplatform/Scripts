!#/bin/bash

git remote show origin | sed -n '/HEAD branch/s/.*: //p'
