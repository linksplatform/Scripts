#!/bin/bash
find . -name *.cs -exec perl -0777pi -e 's~(^\s*/{3}.+(\s)+)+(?<save>(^\s*((\[MethodImpl\(MethodImplOptions\.AggressiveInlining\)\])|(\[((Fact)|(Theory))\]))\s+)*^\s+(private|class))~$+{save}~gm' {}  \;
