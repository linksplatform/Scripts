#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

sudo apt-get update
sudo apt-get install -y texlive texlive-lang-cyrillic texlive-latex-extra python-pygments ghostscript

# Generate tex file using the combined format script
bash format-csharp-document.sh > document.tex

# Generate pdf
latex -shell-escape document.tex
makeindex document
latex -shell-escape document.tex
dvipdf document.dvi document.pdf
dvips document.dvi

# Copy pdf to publish location (will be used in the next script)
mkdir -p _site
cp document.pdf "_site/Platform.$REPOSITORY_NAME.pdf"

# Clean up
rm document.tex
rm document.dvi
rm document.pdf