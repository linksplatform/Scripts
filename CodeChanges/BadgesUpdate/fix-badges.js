#!/usr/bin/env node

const fs = require('fs').promises;
const path = require('path');

// Replace buildstats.info with shields.io
function replaceBuildStats(content) {
  return content.replace(/https:\/\/buildstats\.info\/nuget\/([^\/\)]+)/g, (match, packageName) => {
    // Correct placement of "?label=nuget&style=flat" inside the markdown link parentheses
    return `https://img.shields.io/nuget/v/${packageName}?label=nuget&style=flat`;
  });
}

// Recursively get all .md files in a directory
async function getAllMdFiles(dir, fileList = []) {
  const files = await fs.readdir(dir);

  for (const file of files) {
    const filePath = path.join(dir, file);
    try {
      const stat = await fs.lstat(filePath);

      if (stat.isSymbolicLink()) {
        console.log(`Skipping symbolic link: ${filePath}`);
        continue; // Skip symbolic links
      }

      if (stat.isDirectory()) {
        await getAllMdFiles(filePath, fileList);
      } else if (path.extname(file) === '.md') {
        fileList.push(filePath);
      }
    } catch (error) {
      console.error(`Error processing file: ${filePath} - ${error.message}`);
    }
  }

  return fileList;
}

// Process a single file
async function processFile(filePath) {
  try {
    const content = await fs.readFile(filePath, 'utf8');
    const updatedContent = replaceBuildStats(content);

    if (content !== updatedContent) {
      await fs.writeFile(filePath, updatedContent, 'utf8');
      console.log(`Updated: ${filePath}`);
    } else {
      console.log(`No updates needed: ${filePath}`);
    }
  } catch (error) {
    console.error(`Error processing file: ${filePath} - ${error.message}`);
  }
}

// Main function
async function updateBadgesInDirectory(dirPath) {
  try {
    const mdFiles = await getAllMdFiles(dirPath);

    for (const filePath of mdFiles) {
      await processFile(filePath);
    }
  } catch (error) {
    console.error(`Error processing files: ${error.message}`);
  }
}

// CLI entry point
(async () => {
  if (process.argv.length < 3) {
    console.error('Please provide the path to the folder containing .md files.');
    process.exit(1);
  }

  const targetDir = process.argv[2];
  try {
    const stat = await fs.lstat(targetDir);
    if (!stat.isDirectory()) {
      console.error('The provided path is not a directory.');
      process.exit(1);
    }

    await updateBadgesInDirectory(targetDir);
  } catch (error) {
    console.error(`The provided folder does not exist or cannot be accessed: ${error.message}`);
    process.exit(1);
  }
})();