---
title: "Git - Tips and Tricks [PART 1]"
date: 2021-09-19T21:38:28+08:00
draft: false
toc: true
---

## Introduction

**[Git](https://git-scm.com)** is a very useful utility. There are alot of ways to do one particular thing. This post is made to share what I know and use in git. Bear in mind, I won't be touching the basics as if you're reading this post, I assume that you know the basics of git.

### Making commits

It is wise for one to make proper commit history for their project. A proper commit history provides clarity onto what is the progress of the project while makes it easier to find bugs if any. You can make any kind of explanatory commits but my personal preference is the format "prefix: what you have changed" with an optional explanation. Prefix would be the file and/or directory name that you have modified. 

* Let's say you've made a commit but there's a typo in the commit message, what you can do is use the ```--amend``` option in git. The syntax goes as below:

```shell
git commit --amend -m "new commit message"
```

* Next, let's say you would want to add a co-author to your commit, here's how one would do it:

```shell
git commit -m "your commit message" -m "Co-authored-by: name <name@mail.com>"
```

* Maybe you are using someone else's work and you do want to add author, the best way for this would be to use the ```--author``` option. Here's how it goes:

```shell
git commit -m "your commit message" --author "name <name@mail.com>"
```

### Fixing commit history

* Let's say you've made some bad commits and would like to erase it, I'd suggest resetting hard and force pushing. Get the commit hash of the commit before the messed up commits and run this command:

```shell
git reset --hard commitHash
```

* Then you can either make proper commits and/or force push by this:

```shell
git push -f
```

* You can also squash your commits and force push. With the commit hash of the commit before the messed up commits, run this command:

```shell
git rebase -i commitHash
```

* Then you probably would end up in vim(in my case that's my preferred editor for git). In vim, you can do this:

```vim
:%s/pick/squash/g
```

* If you're using any other editor, find out if there's any regex features in your editor or just manually swap it to squash. 

* Then replace the first squash with pick and save.

* Then you'll come to the commit message screen, I'd suggest adding a _[SQUASH]: what you've changed_ for better clarity.

* Save it and exit. Then you're done.

### Checking commit history

You can check your commit history with git too. There's a choice for you to either look at a specific commit content or the entire repository's commit history or even both at the same time.

* For looking at the commit history in general you can do this:

```shell
git log
```

* For looking at the commit history in a oneliner you can do this:

```shell
git log --oneline
```

* For looking at the commit history and the content of each commits:

```shell
git log -p
```

* For looking at the commit content of a specific commit:

```shell
git show commitHash
```

### Picking commits from other repositories

You can pick commmits from other repositories in several ways. You can either fetch the repository and pick it or wget the commit as a patch and apply it with ```git am```.

* To fetch the repository and pick a couple of commits, first fetch the repo and then grab the commit hash of the commit before the HEAD of the commit you wanna pick and the commit hash before the first commit you would want to pick. Here's how it goes:

```shell
git fetch https://linktorepo.com branch
git cherry-pick startHash^...endHash
```

* To pick one commit from a repository, you'll need to wget it as a patch, I'm sure most Git repository hosting services have the option to download commits as patches. So here's how it'd go:

```shell
wget https://linktopatch.com/xyz.patch
git am xyz.patch
```

### Merging branches/tags

You can merge branches or tags from other repositories by either fetching and merging them or directly merging them. In my opinion, there's hardly any difference between fetching and merging vs directly merging them. 

* To merge a branch/tag of a specific repository by fetching and merging it:

```shell
git fetch https://linktorepo.com branch/tag
git merge FETCH_HEAD
```

* To merge a branch/tag of a specific repository by directly merging it:

```shell
git pull https://linktorepo.com branch/tag
```

## Conclusion

At this point, I believe I can write more but it would be better to split it into a 2nd post. Hope this post helped and stay tuned for the 2nd post :)

