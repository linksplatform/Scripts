sed -i '' 's/net7/net8/g' ./**/*/.github/**/*.yml

sed -i '' 's/net7/net8/g' ./**/*.csproj

# Remove duplicate target frameworks (e.g., net8;net8 -> net8)
sed -i '' 's|<TargetFrameworks>net8;net8</TargetFrameworks>|<TargetFramework>net8</TargetFramework>|g' ./**/*.csproj

perl -0777 -pi -e 's|<PackageReleaseNotes>.*?</PackageReleaseNotes>|<PackageReleaseNotes>Update target framework from net7 to net8.</PackageReleaseNotes>|gs' ./**/*.csproj