#!/usr/bin/env bash
# Local Jekyll server for this site.
# macOS system Ruby is intentionally not used: this project requires Ruby 3+.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# Jekyll Scholar parses UTF-8 characters from the bibliography and talk metadata.
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-${LANG}}"
if [[ "${RUBYOPT:-}" != *-EUTF-8* ]]; then
  export RUBYOPT="${RUBYOPT:+${RUBYOPT} }-EUTF-8"
fi

# Find a compatible Ruby without depending on one user's Homebrew internals.
# A caller may still provide RUBY_BIN as a directory containing ruby.
RUBY_CANDIDATES=()
if [[ -n "${RUBY_BIN:-}" ]]; then
  RUBY_CANDIDATES+=("${RUBY_BIN}/ruby")
fi
if command -v ruby >/dev/null 2>&1; then
  RUBY_CANDIDATES+=("$(command -v ruby)")
fi
if command -v brew >/dev/null 2>&1; then
  if homebrew_prefix="$(brew --prefix 2>/dev/null)"; then
    # Homebrew itself carries a portable Ruby used by some installations.
    # Discover its versioned directory instead of pinning a user's path.
    shopt -s nullglob
    RUBY_CANDIDATES+=("${homebrew_prefix}"/Library/Homebrew/vendor/portable-ruby/*/bin/ruby)
    shopt -u nullglob
  fi
  if homebrew_repository="$(brew --repository 2>/dev/null)"; then
    shopt -s nullglob
    RUBY_CANDIDATES+=("${homebrew_repository}"/Library/Homebrew/vendor/portable-ruby/*/bin/ruby)
    shopt -u nullglob
  fi
  if ruby_prefix="$(brew --prefix ruby 2>/dev/null)"; then
    RUBY_CANDIDATES+=("${ruby_prefix}/bin/ruby")
  fi
fi
RUBY_CANDIDATES+=(
  /opt/homebrew/opt/ruby/bin/ruby
  /usr/local/opt/ruby/bin/ruby
)

RUBY=""
for candidate in "${RUBY_CANDIDATES[@]}"; do
  if [[ -x "$candidate" ]] && "$candidate" -e 'exit(RUBY_VERSION.to_f >= 3.0 ? 0 : 1)' 2>/dev/null; then
    RUBY="$candidate"
    break
  fi
done

if [[ -z "$RUBY" ]]; then
  echo "A compatible Ruby (3.0 or newer) was not found." >&2
  echo "Install it with Homebrew (brew install ruby), then run ./run.sh again." >&2
  exit 1
fi

RUBY_DIR="$(dirname "$RUBY")"
export PATH="${RUBY_DIR}:${PATH}"

# Run Bundler through the selected Ruby so a system Bundler cannot be paired
# accidentally with a different Ruby installation.
BUNDLE=("$RUBY" -S bundle)
if ! "${BUNDLE[@]}" --version >/dev/null 2>&1; then
  echo "Bundler was not found for ${RUBY}." >&2
  echo "Install the Bundler version required by Gemfile.lock, then run ./run.sh again." >&2
  exit 1
fi

export BUNDLE_PATH="${ROOT}/vendor/bundle"
export BUNDLE_JOBS="${BUNDLE_JOBS:-4}"
export BUNDLE_RETRY="${BUNDLE_RETRY:-3}"

if ! "${BUNDLE[@]}" check >/dev/null 2>&1; then
  "${BUNDLE[@]}" install --jobs "${BUNDLE_JOBS}" --retry "${BUNDLE_RETRY}"
fi

exec "${BUNDLE[@]}" exec jekyll serve "$@"
