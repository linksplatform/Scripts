find . -name '*.yml' -exec sed -i '' 's|actions/checkout@v[0-3]|actions/checkout@v4|g' {} +