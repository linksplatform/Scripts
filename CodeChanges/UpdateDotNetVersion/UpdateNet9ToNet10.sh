sed -i '' 's/net9/net10/g' ./**/*/.github/**/*.yml

sed -i '' 's/net9/net10/g' ./**/*.csproj

# Remove duplicate target frameworks (e.g., net10;net10 -> net10)
sed -i '' 's|<TargetFrameworks>net10;net10</TargetFrameworks>|<TargetFramework>net10</TargetFramework>|g' ./**/*.csproj

perl -0777 -pi -e 's|<PackageReleaseNotes>.*?</PackageReleaseNotes>|<PackageReleaseNotes>Update target framework from net9 to net10.</PackageReleaseNotes>|gs' ./**/*.csproj
