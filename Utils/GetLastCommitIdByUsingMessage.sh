#!/bin/bash
git log --oneline | grep -o -m 1 'Commit message' | perl -pe 's~(\S*).+~$1~g'
