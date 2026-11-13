#!/bin/sh
# The `build` check: the theme's demo site, as its demo deploy builds it: from the repository's root with
# demoSite/hugo.toml, whose module mounts take the content and layouts from demoSite/ and everything else from the
# theme. The theme needs Hugo extended (theme.toml: min_version 0.128) for its SCSS; the pinned Hugo of yggdrasil.yml
# is extended and newer. Hugo's deprecation warnings (languageCode, libsass) are upstream's and do not fail it: a
# template or SCSS error does, and so does a site with no home page.
#
# yggdrasil.yml runs it in the pinned Hugo image from the repository's root. The site goes to a temporary directory;
# only Hugo's cache, resources/ (ignored by git), is written to the checkout. By hand:
#   docker run --rm -v "$PWD:/src" -w /src <image from yggdrasil.yml> sh ci/build.sh
set -eu

# The repository's root, wherever this is run from.
cd "$(dirname "$0")/.."

out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT

hugo version
hugo --config demoSite/hugo.toml --destination "$out" --printI18nWarnings --printPathWarnings
test -s "$out/index.html"
