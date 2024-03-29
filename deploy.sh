#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date +"%Y%m%d-%H%M"`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -S -s -m "$msg"

# Push source and build repos.
git push 

# Come Back up to the Project Root
cd ..

git add .
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -S -s -m "$msg"

git push

#curl -X POST https://api.telegram.org/bot$TOKEN/sendMessage -d chat_id=-1001361882613 -d "text=Rebuilt site at $(date +"%Y%m%d-%H%M")"
