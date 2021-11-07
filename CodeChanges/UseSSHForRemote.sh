#!/bin/bash
repository_name=$(git remote show origin | grep 'Fetch URL.*' | perl -pe 's~.*\/~$1~g'); git remote remove origin; git remote add origin git@github.com:linksplatform/${repository_name}.git
