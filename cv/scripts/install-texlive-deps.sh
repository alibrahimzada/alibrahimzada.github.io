#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_FILE="${SCRIPT_DIR}/../texlive-packages.txt"

if command -v tlmgr >/dev/null 2>&1; then
  TLMGR="$(command -v tlmgr)"
elif [[ -x /Library/TeX/texbin/tlmgr ]]; then
  TLMGR="/Library/TeX/texbin/tlmgr"
else
  echo "tlmgr was not found. Install TeX Live or MacTeX first." >&2
  exit 1
fi

packages=()
while IFS= read -r line || [[ -n "${line}" ]]; do
  line="${line%%#*}"
  line="${line//[[:space:]]/}"
  [[ -n "${line}" ]] && packages+=("${line}")
done < "${PACKAGE_FILE}"

if [[ "$(id -u)" -eq 0 ]]; then
  "${TLMGR}" update --self
  "${TLMGR}" install "${packages[@]}"
else
  sudo "${TLMGR}" update --self
  sudo "${TLMGR}" install "${packages[@]}"
fi

echo "TeX Live dependencies installed. Build with: latexmk -pdf -jobname=cv main.tex"
