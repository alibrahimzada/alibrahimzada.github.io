#!/bin/sh

set -eu

cd "$(dirname "$0")"

pdflatex -jobname=cv -interaction=nonstopmode -file-line-error main.tex
biber cv
pdflatex -jobname=cv -interaction=nonstopmode -file-line-error main.tex
pdflatex -jobname=cv -interaction=nonstopmode -file-line-error main.tex
