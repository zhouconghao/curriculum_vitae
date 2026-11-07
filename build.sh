#!/bin/zsh
# Build both CV variants and refresh the website copy (root cv.pdf).
set -e
cd "$(dirname "$0")"
( cd public  && latexmk -pdf -synctex=1 -interaction=nonstopmode cv.tex )
( cd private && latexmk -pdf -interaction=nonstopmode cv_private.tex )
# The public CV must never mention drafts or papers in preparation.
if pdftotext public/cv.pdf - | grep -qiwE 'draft|in prep'; then
    echo "ERROR: 'draft' or 'in prep' appears in public/cv.pdf; cv.pdf (website) not updated." >&2
    exit 1
fi
cp public/cv.pdf cv.pdf
echo "public: public/cv.pdf ($(pdfinfo public/cv.pdf | awk '/^Pages/{print $2}') pages) -> cv.pdf (website)"
echo "private: private/cv_private.pdf ($(pdfinfo private/cv_private.pdf | awk '/^Pages/{print $2}') pages)"
