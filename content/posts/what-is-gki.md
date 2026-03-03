---
title: "What is GKI?"
date: 2026-03-03T17:13:24+08:00
draft: false
toc: true
---

## Introduction

A lot of people have been requesting a quote on quote **proper** guide to work with GKI as it seems very complicated. I'm here to talk about how it _isn't_ complicated and how it works under the hood. By the end of this post, I guarantee you will grasp the fundamentals of GKIs. For the purposes of this post, I am strictly going to talk about kernel v5.10 and newer.

## What the hell is a GKI?

So, GKI stands for Generic Kernel Image. This is Google trying to follow the Linux Desktop way of working with the kernel i.e kernel Image + modules for the particular device handled by insmod/modprobe. But does it work? Yes but no. While it may seem similar in theory, it works on an entirely different manner on a practical side of things.

## So how does GKI work?

The **Generic** in GKI essentially means that the core kernel Image is isolated from the changes required by the **System on a Chip (SoC)** vendor and the device manufacturer. The core kernel Image itself is built, packaged in a boot.img and signed by Google themselves to be utilized by manufacturers in their devices.

The core kernel Image in itself essentially contains Android's edits on the Linux kernel.

Back in the olden days, Android kernels were severely fragmented. The hierarchy of Android kernels were as follows:

**Linux Kernel Stable (LKS) -> Android Common Kernel (ACK) -> Vendor Kernel (CAF/ALPS/SLSI) -> OEM/Device Kernel**

This meant that SoC vendors and OEMs had kernels that were significantly diverged from ACK. This essentially posed multiple issues like:

- Critical security fixes were not able to be backported into the device kernels due to the fragmentation in the kernel.
- Inherent difficulty in merging Long Term Supported (LTS) updates due to the abundance of modifications in the kernel.
- Google had to account for the divergences in the device kernels to implement new features in the Android platform.
- Contribution to upstream Linux was considered improbable due to the delay introduced in pulling patches.

The hierarchy of Android kernels since the introduction of GKI are as follows (at least as per Google):

**Linux Kernel Stable (LKS) -> Android Common Kernel (ACK) -> Vendor/OEM kernel modules**

GKI technically solves this fragmentation problem by unifying the core kernel Image and moving Vendor and OEM support entirely out of the core kernel into dynamically loadable kernel modules (DLKM). Moreover, a stable Kernel Module Interface (KMI) was introduced to update the core kernel Image and modules independently. 

The Linux community has generally frowned upon the idea of in-kernel ABI stability as seen [here](https://www.kernel.org/doc/Documentation/process/stable-api-nonsense.rst) for mainline kernels as there are different configurations, toolchains and the kernel itself is ever-evolving. However, Android kernels utilize LTS kernels, thus Google introduced a highly-constrained environment to build and develop GKI. These constraints are:

- A single configuration file, called `gki_defconfig` is utilized to build the core kernel Image.
- KMI stability is only retained within the same LTS and Android version of the kernel, such as `android12-5.10`, `android13-5.15`, `android14-6.1` and so on and so forth.
- Only a specific LLVM toolchain supplied in AOSP for the corresponding Android version of the kernel must be utilized to build both the core kernel image and the modules.
- Only a strict set of symbols are to be used as KMI symbols for the vendor modules which are monitored for stability via [ABI monitoring tooling](https://android.googlesource.com/kernel/build/+/refs/heads/main-kernel/abi/). 
  - This essentially means that if a non-KMI recognized symbol is required by a vendor module, it will fail to load.
- After a KMI branch is frozen, changes that break KMI are disallowed. Such changes include:
  - Configuration changes.
  - Kernel code changes throughout core structures.
  - Toolchain updates.

So you may ask, how to figure out what KMI my device is utilizing? That is inherently simple as all you would have to do is parse the kernel version string. For example:

`Linux version 5.10.218-android12-9-00062-ga900d8468ace-ab12946691`

`5.10.218` is the Linux kernel version, `android12` is the Android version that the kernel was launched on, `9` is the current KMI version. The rest are simply build hashes and identifiers which are irrelevant to the KMI version.

You may ask, why is the KMI version different per kernel? That is because each Android GKI kernel starts with KMI version 0, changes either by upstream Linux or ACK maintainers themselves introduce ABI breakages (which may come in the form of critical fixes) that may require a KMI version increment which would require all SoC vendors and OEMs to rebuild their modules against the new GKI which has the KMI version incremented.
  
Moving on, DLKMs are split across different partitions in the order of which they are utilized. In a device running a `android12-5.10` kernel, the DLKMs are placed in both the vendor\_boot partition and the vendor\_dlkm partition. The vendor\_boot partition has modules that are required for the recovery environment and early-init. The vendor\_dlkm partition has the rest of the modules. Some devices place ODM-specific modules (which previously were added in /odm/lib/modules/) in a partition called odm\_dlkm.

On devices launched with Android 13 (and subsequently an `android13-*` kernel), a new partition is introduced in the form of system\_dlkm. This partition essentially extends the constraints of GKI by isolating the core GKI kernel code from the SoC vendor and OEM kernel code. system\_dlkm is built alongside the GKI environment and the modules are signed alongside the core kernel Image thus GKI and GKI modules are updated independently from the rest of the DLKMs. ABI stability is not maintained for GKI modules thus they must be updated alongside the GKI.

On a side note: Pixels utilize a new partition called vendor\_kernel\_boot to store the modules that were supposed to be stored in vendor\_boot.
  
Essentially, all of this should reduce fragmentation among SoC vendors and OEMs but it only makes things far more complex for a downstream developer such as you and I. Considering the fact that SoC vendors and OEMs require such significant changes in the core kernel to build their vendor modules, Google does not accept all of the changes that are required. Thus, SoC vendors and OEMs have to opt for a different solution.

The solution in question is to utilize a second kernel as the ABI for their vendor kernel modules. This makes the workflow be like this:

- common (ACK) - Utilized for GKI and GKI modules.
- vendor-kernel - Utilized for vendor kernel modules ABI.
- vendor-modules - Source code for the vendor kernel modules.
- vendor-devicetrees - Source code for the DTB(O)s.

These are utilized with build systems to build GKI, GKI modules, vendor kernel modules and DTB(O)s.

## How to build GKI?

Considering the fact that this post in itself is quite long, it only makes sense for me to talk more about that on the second post, so stay tuned :)
