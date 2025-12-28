#!/bin/bash

# Update .NET 6 to .NET 10
sed -i '' 's/net6\.0/net10.0/g' ./**/*.csproj
sed -i '' 's/net6/net10/g' ./**/*/.github/**/*.yml

# Update .NET 7 to .NET 10
sed -i '' 's/net7\.0/net10.0/g' ./**/*.csproj
sed -i '' 's/net7/net10/g' ./**/*.csproj
sed -i '' 's/net7/net10/g' ./**/*/.github/**/*.yml

# Update .NET 8 to .NET 10
sed -i '' 's/net8\.0/net10.0/g' ./**/*.csproj
sed -i '' 's/net8/net10/g' ./**/*.csproj
sed -i '' 's/net8/net10/g' ./**/*/.github/**/*.yml

# Update .NET 9 to .NET 10
sed -i '' 's/net9\.0/net10.0/g' ./**/*.csproj
sed -i '' 's/net9/net10/g' ./**/*.csproj
sed -i '' 's/net9/net10/g' ./**/*/.github/**/*.yml

# Handle other .NET versions to .NET 10
sed -i '' 's/netcoreapp3\.1/net10.0/g' ./**/*.csproj
sed -i '' 's/net5\.0/net10.0/g' ./**/*.csproj
sed -i '' 's/netstandard2\.0/net10.0/g' ./**/*.csproj
sed -i '' 's/netstandard2\.1/net10.0/g' ./**/*.csproj

# Remove duplicate target frameworks (e.g., net10;net10 -> net10)
sed -i '' 's|<TargetFrameworks>net10;net10</TargetFrameworks>|<TargetFramework>net10</TargetFramework>|g' ./**/*.csproj
sed -i '' 's|<TargetFrameworks>net10\.0;net10\.0</TargetFrameworks>|<TargetFramework>net10.0</TargetFramework>|g' ./**/*.csproj

# Update package release notes to reflect the upgrade
perl -0777 -pi -e 's|<PackageReleaseNotes>.*?</PackageReleaseNotes>|<PackageReleaseNotes>Update target framework to net10.</PackageReleaseNotes>|gs' ./**/*.csproj

echo "Updated all .NET projects to .NET 10"
