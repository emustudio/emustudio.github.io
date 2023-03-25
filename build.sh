#!/bin/bash

# Tests before build
echo "Checking {:target=\"_blank\"} ..."
find _documentation/ -type f -name "*.md" -print0 | xargs -0 grep -e "\s\[[^]]*\]\[[^]]*\][^{]" | grep -v "\\[instantiation\\]" | grep -v "\\[initialization\\]" | grep -v "\\[memoryBanks\\]" | grep -v "\\[ssem-mem\\]"
if [[ "$?" -eq 0 ]]; then
  echo "  Problem"
  exit 1
fi

# Build
echo Deleting generated sites
rm -rf ./documentation/
bundle exec jekyll clean

echo Building site...
cd _documentation || exit
. build.sh
cd ..

JEKYLL_ENV=production bundle exec jekyll build --verbose

# Tests after build
echo Checking images...
find documentation/ -type f -name "*.html" -print0 | xargs -0 grep "{imagepath}"
if [[ "$?" -eq 0 ]]; then
  echo "  Problem"
  exit 1
fi

echo Checking if baseurl ends with slash...
grep -r href=\" . | grep 'href=\"{{ *site\.baseurl *}}[^/{]' | grep -vE "_posts\|_site|documentation"
if [[ "$?" -eq 0 ]]; then
  echo "  Problem"
  exit 1
fi

echo 'Checking for accidental spaces between link and target="_blank"'
grep -r '\s{:target="_blank"}' .
if [[ "$?" -eq 0 ]]; then
  echo "  Problem"
  exit 1
fi
