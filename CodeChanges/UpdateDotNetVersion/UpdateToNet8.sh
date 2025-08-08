#!/bin/bash

# Update .NET 6 to .NET 8
sed -i '' 's/net6\.0/net8.0/g' ./**/*.csproj
sed -i '' 's/net6/net8/g' ./**/*/.github/**/*.yml

# Update .NET 7 to .NET 8  
sed -i '' 's/net7\.0/net8.0/g' ./**/*.csproj
sed -i '' 's/net7/net8/g' ./**/*.csproj
sed -i '' 's/net7/net8/g' ./**/*/.github/**/*.yml

# Handle other .NET versions to .NET 8
sed -i '' 's/netcoreapp3\.1/net8.0/g' ./**/*.csproj
sed -i '' 's/net5\.0/net8.0/g' ./**/*.csproj
sed -i '' 's/netstandard2\.0/net8.0/g' ./**/*.csproj
sed -i '' 's/netstandard2\.1/net8.0/g' ./**/*.csproj

# Remove duplicate target frameworks (e.g., net8;net8 -> net8)
sed -i '' 's|<TargetFrameworks>net8;net8</TargetFrameworks>|<TargetFramework>net8</TargetFramework>|g' ./**/*.csproj
sed -i '' 's|<TargetFrameworks>net8\.0;net8\.0</TargetFrameworks>|<TargetFramework>net8.0</TargetFramework>|g' ./**/*.csproj

# Update package release notes to reflect the upgrade
perl -0777 -pi -e 's|<PackageReleaseNotes>.*?</PackageReleaseNotes>|<PackageReleaseNotes>Update target framework to net8.</PackageReleaseNotes>|gs' ./**/*.csproj

echo "Updated all .NET projects to .NET 8"