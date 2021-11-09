#!/bin/bash
git remote show origin | grep 'Fetch URL.*' | perl -pe 's~.*\/~$1~g'
