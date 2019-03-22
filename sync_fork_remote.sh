#!/usr/bin/env bash

git remote add upstream https://github.com/skywind3000/vim-init
git remote update upstream
git checkout master
git rebase upstream/master
