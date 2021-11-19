#!/bin/bash

# Make sure fd is installed!

fd -p ".+/csharp/.+\.(Tests)|(Benchmarks)/*" -e cs -x perl -0777pi -pe "s~^ */{3}.*\s~~gm" {}
