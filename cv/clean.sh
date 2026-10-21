#!/bin/sh

set -eu

cd "$(dirname "$0")"

rm -f \
  cv.pdf \
  cv.aux \
  cv.bbl \
  cv.bcf \
  cv.blg \
  cv.fdb_latexmk \
  cv.fls \
  cv.idx \
  cv.ilg \
  cv.ind \
  cv.log \
  cv.lof \
  cv.lot \
  cv.nav \
  cv.out \
  cv.run.xml \
  cv.snm \
  cv.synctex.gz \
  cv.toc \
  cv.vrb
