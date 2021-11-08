#!/bin/bash
find . -type f -name "*.h" -print0 | xargs -0 perl -0777pi -e 's~(#pragma once(\r|\n|\s)+)?#ifndef [A-Za-z_]+(\r|\n|\s)+#define [A-Za-z_]+(?<BODY>(.|\r|\n|\s)+[^\r\n\s])+(\r|\n|\s)+#endif((\r|\n|\s)*\/\/(\r|\n|\s)*[A-Za-z_]+(\r|\n|\s)*)?~#pragma once$+{BODY}\n~gm'