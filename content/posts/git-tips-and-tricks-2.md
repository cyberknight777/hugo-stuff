---
title: "Git - Tips and Tricks [PART 2]"
date: 2025-06-20T23:14:52+08:00
draft: false
toc: true
---

## Introduction

It has been 4 years since my last tips and tricks post for Git, thus it is time to make a part 2 expanding upon more git functionalities that are useful and should be known by the masses.

### Getting a list of commit hashes

For example, if you have made a number of changes and you want to rebase those changes off of another branch but you're like me and you don't prefer to use ```git rebase```, then you may try the command below to get the list of commit hashes of the changes you've made.

* First and foremost you need two things, commit hash of the last commit you made and the commit hash of the commit BEFORE the first commit you made. Then you can proceed to do this:

```shell
git log --oneline lastcommithash...beforefirstcommithash --format=%H --reverse
```

Explanation: This will provide a list of commit hashes in a reversed order (as in it will show the first commit hash to the last commit hash). %H stands for full hash, you can get an abbreviated list by passing %h instead.

### Rerere

Rerere is a hidden functionality in git that stands for "reuse recorded resolution", which means it caches your conflict resolutions and automatically applies said resolutions when you have a similar conflict again. This is a very useful feature that specifically helps with merges.

* To enable it globally, all you'd have to do is this:

```shell
git config --global rerere.enabled true
```

Explanation: This sets rerere to be enabled by default in .gitconfig.

* If you want to perform a massive merge but you do not want to deal with the conflicts and you have a reference repo that has already dealt with the conflicts, you can make your life easier by simply:

```shell
git clone referencerepo ref
cd ref
wget https://github.com/git/git/raw/master/contrib/rerere-train.sh
chmod +x rerere-train.sh
./rerere-train.sh
cp -r .git/rr-cache /path/to/your/repo/.git/
```

Explanation: With this you have copied the recorded resolution cache to your repo and when you attempt to do the massive merge, it will resolve almost every similar conflict there is.

### Strip history

This is useful in the event where you need to push a repo but the commit history is too large / is LFS-bound.

* You can strip the history down to one commit to be able to push it by doing this:

```shell
git reset $(git commit-tree HEAD^{tree} -m "stripped import")
```

Explanation: This strips the entire commit history to one commit called stripped import.

### Format patch

Sometimes you may want to get .patch files of the commits you've made, you can do that by using ```git format-patch```.

* To get one particular commit as a .patch:

```shell
git format-patch -1 commitHash
```

* To get a list of commits as .patch files:

```shell
git format-patch commitHash
```

* To print out the list of commits to stdout:

```shell
git format-patch commitHash --stdout
```

You can extend this to save to a file by doing ```> name.patch```.

### Stash

Sometimes you're making some changes but you want to store it and work on something new. You can do that via ```git stash```.

* To stash current changes:

```shell
git stash
```

* To view files of stashed changes:

```shell
git stash show
```

* To view actual stashed changes:

```shell
git stash show -p
```

* To apply stashed changes:

```shell
git stash apply
```

* To clear stashed changes:

```shell
git stash clear
```

### Checkout

I'm not gonna talk about the basics of checkout but I will showcase 2 cool ways to use it.

* To checkout a file from a different commit hash:

```shell
git checkout commitHash /path/to/file
```

* To checkout and create a new branch:

```shell
git checkout FETCH_HEAD -b newbranch
```

### Multiple branches on multiple remotes

Sometimes you may have a repo that is on multiple remotes, the "easy" way to deal with this is to have multiple copies of the repo itself. While that solution _works_, it is not ideal.

* You can have multiple branches of the same name of multiple remotes with differing histories by doing this:

```shell
git remote add newremote link.git
git fetch newremote foo
git checkout FETCH_HEAD -b foo-new
git config push.default upstream
git config branch.autoSetupMerge
git commit --allow-empty -m "test"
git push -u newremote foo-new:foo
```

Explanation: This fetches the branch from a new remote which has the same branch name as your current remote, checks out to it and creates a new branch name and then configures push.default to push to the remote that it was pulled from i.e newremote. Then, it configures branch.autoSetupMerge for git to acknowledge that git pull will pull from the remote that it was originally pulled from instead of origin. Finally, it sets up the remote for the new branch name to push to the upstream branch name to not create a new branch unnecessarily.

### Large File Storage (LFS)

Dealing with LFS blobs in repos can be a tad bit tedious and confusing. I will showcase some commands that are useful in this case.

* To setup LFS in your repo:

```shell
git lfs install
git lfs track /path/to/largefile
```

Explanation: This installs global hooks for LFS and tracks the large file in a .gitattributes file in the repo.

* To find what file is a largefile that prevents pushing normally, you need the blob id to do this:

```shell
git ls-tree -r HEAD | grep $BLOB_ID
```

Explanation: This shows you the exact largefile for you to track via LFS.

* To check all largefiles and to get the blob id you can do this:

```shell
git lfs ls-files
```

### Rm

Sometimes you may want to remove a file and commit it, usually you would ```rm /path/to/file && git add /path/to/file```, but you can simply use ```git rm```.

There is no need to showcase how it works as it is merely the same as regular rm except it stages the files/directories that you have removed.


### Reflog

In some cases, after rewriting history by rebasing, you may want to check your previous HEAD as to what exactly the list of commits in there had.

* You can check the history of what you have amended, rebased and dropped, edited and so on by doing this:

```shell
git reflog
```

### Regular Expression with git

Sometimes you may want to perform a regex on multiple files on a repo.

* You can perform a regex with an iteration of this:

```shell
git grep -l foo | xargs sed -i 's/foo/bar/g'
```

Explanation: This will grep through the repository for the word foo and list the filenames including the path to it and then pipe it to sed to perform a regular expression.

## Conclusion

For the moment, this is more than enough for a part 2, perhaps I would work on a part 3 someday in the near future.