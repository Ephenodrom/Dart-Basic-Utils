#!/usr/bin/env sh

# abort on errors
set -e

# build
yarn build

# navigate into the build output directory
cd docs/.vuepress/dist

git init
git checkout -B gh-pages
git remote add origin https://github.com/Ephenodrom/dart-basic-utils.git
git add .
git commit -m 'deploy'

git push -f --set-upstream origin gh-pages

cd -
