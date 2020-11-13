#!/bin/sh

# If a command fails then the deploy stops
# set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Build the project.
#hugo # if using a theme, replace with `hugo -t <YOURTHEME>`
printf "First, we pull for changes"

git pull

docker run --rm -it \
  -v $(pwd):/src \
  klakegg/hugo:0.78.1-ext-ubuntu


# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -a -m "$msg"

# Push source and build repos.
git push
