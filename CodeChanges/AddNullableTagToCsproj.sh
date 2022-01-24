#!/bin/bash

find . -name *.csproj -exec perl -0777pi -e 's~(?<before_nullable>^ *?\<PropertyGroup\>((?!<Nullable>).)*?)(?<after_nullable>(?<property_group_indent>^\s*)<\/PropertyGroup\>)~$+{before_nullable}$+{property_group_indent}  <Nullable>enable</Nullable>\n$+{after_nullable}~ms' {}  \;
