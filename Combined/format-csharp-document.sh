#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Function to detect project structure
detect_project_structure() {
    if [ -d "csharp" ] && [ -d "csharp/Platform.$REPOSITORY_NAME" ]; then
        echo "multi"
    elif [ -f "Platform.$REPOSITORY_NAME.csproj" ]; then
        echo "single"
    else
        echo "unknown"
    fi
}

# Function to clean up auto-generated files for multi-project
cleanup_multi_project() {
    set +e
    find "./csharp/Platform.$REPOSITORY_NAME/obj" -type f -iname "*.cs" -delete 2>/dev/null
    find "./csharp/Platform.$REPOSITORY_NAME.Tests/obj" -type f -iname "*.cs" -delete 2>/dev/null
    set -e
}

# Function to clean up auto-generated files for single-project
cleanup_single_project() {
    find ./obj -type f -iname "*.cs" -delete 2>/dev/null || true
}

# Function to process files for multi-project
process_multi_project_files() {
    # Project files
    find "./csharp/Platform.$REPOSITORY_NAME" -type f -iname '*.cs' | sort -b | python format-csharp-files.py
    
    # Tests files (if they exist)
    if [ -d "./csharp/Platform.$REPOSITORY_NAME.Tests" ]; then
        find "./csharp/Platform.$REPOSITORY_NAME.Tests" -type f -iname '*.cs' | sort -b | python format-csharp-files.py
    fi
}

# Function to process files for single-project
process_single_project_files() {
    # Project files
    find . -type f -iname '*.cs' | sort -b | python format-csharp-files.py
}

# Function to output LaTeX header
output_latex_header() {
    printf """
\\documentclass[11pt,a4paper,fleqn]{report}
\\usepackage[left=5mm,top=5mm,right=5mm,bottom=5mm]{geometry}
\\textwidth=200mm
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage[T2A]{fontenc}
\\usepackage{fvextra}
\\usepackage{minted}
\\usemintedstyle{vs}
\\usepackage{makeidx}
\\usepackage[columns=1]{idxlayout}
\\makeindex
\\renewcommand{\\thesection}{\\arabic{chapter}.\\arabic{section}}
\\setcounter{chapter}{1}
\\setcounter{section}{0}
\\usepackage[tiny]{titlesec}
\\titlespacing\\chapter{0mm}{0mm}{0mm}
\\titlespacing\\section{0mm}{0mm}{0mm}
\\DeclareUnicodeCharacter{221E}{\\ensuremath{\\infty}}
\\DeclareUnicodeCharacter{FFFD}{\\ensuremath{ }}
\\usepackage{fancyhdr}
\\pagestyle{fancy}
\\fancyhf{}
\\fancyfoot[C]{\\thepage}
\\renewcommand{\\headrulewidth}{0mm}
\\renewcommand{\\footrulewidth}{0mm}
\\renewcommand{\\baselinestretch}{0.7}
\\begin{document}
\\sf
\\noindent{\\Large LinksPlatform's Platform.${REPOSITORY_NAME} Class Library}
"""
}

# Function to output LaTeX footer
output_latex_footer() {
    printf """
\\printindex
\\end{document}
"""
}

# Ensure format-csharp-files.py exists
ensure_format_script() {
    local script_path=""
    if [ "$PROJECT_TYPE" = "multi" ] && [ -f "format-csharp-files.py" ]; then
        script_path="format-csharp-files.py"
    elif [ "$PROJECT_TYPE" = "single" ] && [ -f "format-csharp-files.py" ]; then
        script_path="format-csharp-files.py"
    elif [ -f "../Utils/format-csharp-files.py" ]; then
        cp "../Utils/format-csharp-files.py" .
        script_path="format-csharp-files.py"
    elif [ -f "MultiProjectRepository/format-csharp-files.py" ]; then
        cp "MultiProjectRepository/format-csharp-files.py" .
        script_path="format-csharp-files.py"
    elif [ -f "SingleProjectRepository/format-csharp-files.py" ]; then
        cp "SingleProjectRepository/format-csharp-files.py" .
        script_path="format-csharp-files.py"
    else
        echo "format-csharp-files.py not found. Please ensure it's available."
        exit 1
    fi
}

# Main execution
PROJECT_TYPE=$(detect_project_structure)

echo "Detected project structure: $PROJECT_TYPE"

case $PROJECT_TYPE in
    "multi")
        cleanup_multi_project
        ;;
    "single")
        cleanup_single_project
        ;;
    "unknown")
        echo "Could not detect project structure. Expected either:"
        echo "  Multi-project: ./csharp/Platform.\$REPOSITORY_NAME/ directory"
        echo "  Single-project: Platform.\$REPOSITORY_NAME.csproj file"
        exit 1
        ;;
esac

# Download fvextra package
wget https://raw.githubusercontent.com/gpoore/fvextra/cc1c0c5f7b92023cfec67084e2a87bdac520414c/fvextra/fvextra.sty

# Ensure format script is available
ensure_format_script

# Output LaTeX header
output_latex_header

# Process files based on project type
case $PROJECT_TYPE in
    "multi")
        process_multi_project_files
        ;;
    "single")
        process_single_project_files
        ;;
esac

# Output LaTeX footer
output_latex_footer