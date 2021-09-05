---
title: "How to Rebase a Kernel"
date: 2021-09-06T02:50:39+08:00
draft: false
toc: true
---

## Introduction

Well, I was feeling bored so I was chatting with a dude called [Anurag](https://t.me/anuragroy) in a group called [DEs/WMs](https://t.me/de_wm) regarding android kernels then he told me how his kernel was underperforming even after ricing it alot. I suggested him to rebase his kernel and he said he was unclear about the mentioned topic, so i wrote a long message onto how one can rebase a kernel and I thought that I should write it as a post in my site. So here I am writing this small guide at 04:30 in the morning.


## What is rebasing a kernel

When you're doing android kernel development, you must've heard the term __rebase__ like a thousand times. What rebase actually means is that you will be using a kernel release from either __[Android Common Kernel(ACK)](https://android.googlesource.com/kernel/common.git)__ or __[Linux Kernel Stable(LKS)](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git)__ or even __[Code Aurora Forum(CAF)](https://source.codeaurora.org/quic/la/kernel/common)__ and then importing your OEM changes on top of it, then just start ricing your kernel :).

## Why do we need to rebase a kernel

You probably should rebase every once in awhile as when you start ricing your kernel, there may be times when your commit history is not managed and completely mismatched. This can actually make life harder for you when you would want to debug an issue in your kernel. Rebasing your kernel gives you clarity onto what may have caused the issue at hand. The next part of this blog will focus onto how one can rebase a kernel.

## How to rebase a kernel

Prerequisites needed :-

	* Knowledge of git
	* Knowledge of C
	* Common sense
	
### Using the right base

This heavily depends on the brand of **[System On a Chip(SOC)](https://en.wikipedia.org/wiki/System_on_a_chip)** you are using in your phone. Let's say you're using a Qualcomm SOC based phone, the best choice would be to use a CAF tag release as a base and work forward with it. You could also use LKS or ACK but the most preferable option would be to use a CAF tag release. Let's say you're using a Mediatek or Exynos SOC based phone, the best choice would be to use an ACK release as a base and work with it. The reason I suggest ACK over LKS is because ACK focuses more on android side of things compared to LKS which is basically generic.

### Importing OEM changes

**Remember, If your OEM kernel source is a Q base, use a Q base kernel from CAF or ACK. Do not use a R base kernel for Q based OEM kernel as it would not work and would throw alot of git conflicts!**

Let's say your OEM releases their kernel source code in [GitHub](https://github.com), the easiest way you can import their changes would be to merge their kernel source. This is an example of how a OnePlus 7 kernel source code for R can be merged on a CAF base.

```shell
git fetch https://github.com/oneplusoss/android_kernel_oneplus_sm8150 oneplus/SM8150_R_10.0

git merge FETCH_HEAD
```

Then of course, you'll have some git conflicts in which you should have the knowledge to compare and fix it. 

**Keep in mind there are some OEMs that release some important drivers in a seperate repository so merge them like I do below for my audio driver.**

```shell
git fetch https://github.com/OnePlusOSS/android_vendor_qcom_opensource_audio_kernel_sm8150 oneplus/SM8150_R_10.0

git merge -s ours --no-commit --allow-unrelated-histories --squash FETCH_HEAD
```

Once that is done, you can start building your kernel and fixing mismerges if any. There is an alternative way to import oem changes manually with better commit history. You can read more about it **[here](https://t.me/LinuxKernelNewbies/183745)**.

Let's say your OEM releases their kernel source as a tarball like Samsung does, what you can do is manually copy pasting each directories from the tarball onto the kernel base, or add the patch that I will be sharing below in the Makefile of the OEM kernel source, rename the OEM kernel source as ```oem```, place it inside of the kernel base and run ```make ARCH=arm64```. 

```git
diff --git a/Makefile b/Makefile
index 4c3b137a7000..d588668d76a8 100644
--- a/Makefile
+++ b/Makefile
@@ -127,6 +127,7 @@ $(CURDIR)/Makefile Makefile: ;
 ifneq ($(words $(subst :, ,$(CURDIR))), 1)
   $(error main directory cannot contain spaces nor colons)
 endif
+KBUILD_COPY :=  $(shell cp -rf $(CURDIR)/../oem/* $(CURDIR)/../)
 
 ifneq ($(KBUILD_OUTPUT),)
 # check that the output directory actually exists
```

**Be sure to remove this after importing OEM changes or you may have your kernel source being copied to ../ everytime.**

Once you're done with that, you can start building your kernel and ricing your kernel.

## Conclusion

Rebasing a kernel or you can call it as bringing up a kernel is actually a simple yet fun process. Since you're doing this on your own, you get to choose what you need and what you don't need for the kernel. By this, you can manage to make a simple yet perfect kernel for yourself. My first ever proper bringup of a kernel is **[DragonHeart](https://github.com/cyberknight777/dragonheart_kernel_oneplus_sm8150)**. It was fun to do that bringup and I'm still learning many new things as I progress with it. 

--- 

I hope maybe you as the reader has gained useful information from this post.

Stay tuned for more of how-to posts from me :)
