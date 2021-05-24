#!/bin/bash

git push
echo "Changing to jekyll folder"
cd /mnt/c/Users/conrada/blogs/blog
echo "Serving site locally"
bundle exec jekyll serve 
