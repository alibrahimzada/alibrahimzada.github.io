# CV

## Install LaTeX dependencies

Install a TeX Live distribution first. On macOS, BasicTeX or MacTeX works. Then install all packages listed in `texlive-packages.txt` at once:

```sh
./scripts/install-texlive-deps.sh
```

The script updates `tlmgr` and installs the package list. It uses `sudo` when needed.

## Build the PDF

```sh
latexmk -pdf -jobname=cv -interaction=nonstopmode -file-line-error main.tex
```

The output is `cv.pdf`. LaTeX auxiliary files and the generated PDF are ignored by Git.

## Website deployment

The website repository builds this CV with pdfLaTeX and TeX Live 2026 on every push and copies the result to `assets/pdf/cv.pdf` before deploying the site. The CV sources live in this `cv/` directory, so the website repository is the only repository needed to maintain them.
