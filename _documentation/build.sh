#!/usr/bin/env bash

current=`pwd`
for d in `find . -name '_config.yml'`; do
  cd `dirname $d`
  JEKYLL_ENV=production bundle exec jekyll build
  cd $current
done