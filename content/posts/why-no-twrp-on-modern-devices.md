---
title: "Why no TWRP on modern devices?"
date: 2025-12-05T00:01:37+08:00
draft: false
toc: false
---

The reason why custom recoveries such as TWRP are obsolete in modern devices is because the practicality of it is inexistent. For example 90% of modern devices do not have a separate recovery partition, rather they use the vendor_boot partition for it. This makes utilizing a custom recovery a tedious process due to the fact that the recovery environment is not completely isolated thus a bootloop is tricky to get out of as you cannot boot into system nor recovery and you cannot flash images all the time in bootloader due to preflash validation error (on motorola specifically). Moreover, with Virtual A/B partitioning system it makes updating the ROM itself a tedious process as back in the day of A-only partitioning system, you can opt not to "include" the recovery of the ROM within the build but you cannot do it on modern devices.

To add on, the functionality of custom recoveries is the same as AOSP recovery. It does not add anything extra as its extra features such as modifying super (which does not work obviously since EROFS), NAND backups (also does not work due to encryption format), and decrypting data (has never been practical due to encryption symbols and such changing on every QPR/android version) being unusable on modern devices. Moreover, you don't have to "flash" anything other than the ROM itself on the recovery. Magisk? Flashing that in recovery has been deprecated for years, official flashing method for magisk is patching the boot.img and flashing that via fastboot. Any other rooting solution? about the same. Gapps? ROMs come bundled with it.

Moving on, there are also security concerns, on modern devices security is prioritized a lot, both by Google and OEMs themselves, thus touching critical partitions is only done via update-binary and not anything else. Also AOSP recoveries do not have the risk of being a POF (Point-Of-Failure) but custom recoveries do due to the tremendous amount of hacks needed for it. 

Custom recoveries also break delta updates because the images themselves don't match the hash/check bits that are needed for delta updates. On G54, the risk of getting hardbricked is high due to ARB, (and MTK + Moto's handling of the preloader partition) so AOSP recovery is as always the safest option.

Moreover, you can flash via sdcard and/or otg using for example an AOSP recovery that is from a LineageOS derivative. This, again makes custom recoveries redundant because it does the exact same thing. To put it in a simple manner, custom recoveries are unneeded and just cause more issues than being "convenient" on modern devices.

One may think that it would be inconvenient to always need a PC to switch ROMs but why not use a ROM that offers OTA updates so you never have to boot into recovery ever after you firstly installed the ROM? That, then would be a far better option instead.
