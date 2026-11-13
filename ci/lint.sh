#!/bin/sh
# The `lint` check: the theme's own linters, installed from package-lock.json (npm ci) and run with its configs.
# ESLint (.eslintrc.yml) checks the theme's JS in assets/js (prism.js, a minified PrismJS build, is ignored there);
# stylelint (.stylelintrc.json) its SCSS in assets/css. style.scss is a Hugo template, not SCSS, so stylelint ignores
# it, and .stylelintrc.json turns off the rules the theme's styles have never followed (modern colour notation,
# ::pseudo-elements, vendor prefixes, descending specificity, class name pattern, keyword case, font name quotes).
# .prettierrc is left out: prettier is not among the dependencies, and a reformat of the templates broke them before.
#
# yggdrasil.yml runs it in the pinned Node image from the repository's root. By hand:
#   docker run --rm -v "$PWD:/src" -w /src <image from yggdrasil.yml> sh ci/lint.sh
set -eu

# The repository's root, wherever this is run from.
cd "$(dirname "$0")/.."

npm ci --no-audit --no-fund
npx --no-install eslint assets/js
npx --no-install stylelint "assets/css/**/*.scss"
