sed -i '' 's/net7/net8/g' .github/**/*.yml

sed -i '' 's/net7/net8/g' ./**/*.csproj

# Remove duplicate target frameworks (e.g., net8;net8 -> net8)
sed -i '' 's/<TargetFrameworks>net8;net8<\/TargetFrameworks>/<TargetFrameworks>net8<\/TargetFrameworks>/g' ./**/*.csproj
