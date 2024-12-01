#!/usr/bin/env zx

// import { $, cd, glob } from 'zx';

async function replaceLicenseExpression(targetPath) {
  if (!targetPath) {
    console.error('Error: Please provide the target path as the first argument.');
    process.exit(1);
  }

  try {
    // Change to the target directory
    cd(targetPath);

    // Find all .csproj files in the directory
    const csprojFiles = await glob('**/*.csproj');

    if (csprojFiles.length === 0) {
      console.log('No .csproj files found in the specified directory.');
      return;
    }

    // Process each .csproj file
    for (const file of csprojFiles) {
      await $`sed -i '' 's|<PackageLicenseExpression>Unlicensed</PackageLicenseExpression>|<PackageLicenseExpression>Unlicense</PackageLicenseExpression>|g' ${file}`;
      console.log(`Updated: ${file}`);
    }

    console.log('Replacement complete.');
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

// Run the script with the first argument as the target path

// console.log(process.argv[3])

replaceLicenseExpression(process.argv[3]);