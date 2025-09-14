# Combined Scripts

This directory contains unified scripts that can work with both single-project and multi-project repository structures.

## How It Works

The scripts automatically detect the project structure:

- **Multi-project**: Looks for `CSHARP_PACKAGE_VERSION.txt` files or `csharp/Platform.$REPOSITORY_NAME/` directory structure
- **Single-project**: Looks for `Platform.$REPOSITORY_NAME.csproj` in the root directory

## Available Scripts

### C# Scripts

1. **publish-csharp-release.sh**
   - Creates GitHub releases for C# packages
   - Multi-project: Uses version from `CSHARP_PACKAGE_VERSION.txt`
   - Single-project: Extracts version from `.csproj` file

2. **push-csharp-nuget.sh**
   - Publishes NuGet packages
   - Multi-project: Uses version from `CSHARP_PACKAGE_VERSION.txt`
   - Single-project: Extracts version from generated package

3. **format-csharp-document.sh**
   - Formats C# code for LaTeX documentation
   - Multi-project: Processes `./csharp/Platform.$REPOSITORY_NAME/` structure
   - Single-project: Processes current directory

4. **generate-csharp-pdf.sh**
   - Generates PDF documentation from C# code
   - Works with output from `format-csharp-document.sh`

5. **publish-csharp-docs.sh**
   - Publishes documentation to GitHub Pages
   - Multi-project: Creates `csharp/` subdirectory structure
   - Single-project: Uses root directory

## Usage

Simply use these scripts as drop-in replacements for the separate single/multi-project scripts. They will automatically adapt to your repository structure.

### Requirements

- `$REPOSITORY_NAME` environment variable must be set
- For GitHub operations: `$GITHUB_TOKEN` environment variable
- For NuGet operations: `$NUGETTOKEN` environment variable

### Example

```bash
export REPOSITORY_NAME="MyLibrary"
export GITHUB_TOKEN="your_token_here"
export NUGETTOKEN="your_nuget_token_here"

# These will work for both single and multi-project repositories
./publish-csharp-release.sh
./push-csharp-nuget.sh
```

## Migration

To migrate from separate scripts:

1. Replace calls to `MultiProjectRepository/script.sh` or `SingleProjectRepository/script.sh`
2. Use the equivalent `Combined/script.sh` instead
3. No other changes needed - the scripts are compatible with existing workflows