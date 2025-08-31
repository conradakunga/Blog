---
layout: post
title: Tip - DriveInfo.AvailableFreeSpace vs DriveInfo.TotalFreeSpace
date: 2025-08-15 11:55:40 +0300
categories:
    - C#
    - .NET
    - Tips
---

The [DriveInfo](https://learn.microsoft.com/en-us/dotnet/api/system.io.driveinfo?view=net-9.0) class has two **similar** properties:

- [AvailableFreeSpace](https://learn.microsoft.com/en-us/dotnet/api/system.io.driveinfo.availablefreespace?view=net-9.0)
- [TotalFreeSpace](https://learn.microsoft.com/en-us/dotnet/api/system.io.driveinfo.totalfreespace?view=net-9.0)

They are similar, but not interchangeable as there is a subtle difference.

The main operating systems support a concept called a [disk quota](https://en.wikipedia.org/wiki/Disk_quota), which allows administrators to set the **allowable amount of disk space that users can be allocated to a user**. [Windows](https://learn.microsoft.com/en-us/windows/win32/fileio/managing-disk-quotas), [macOS](https://discussions.apple.com/thread/253623300) & [Linux/Unix](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/storage_administration_guide/ch-disk-quotas) all implement this in different ways.

The difference between these two properties is that the `AvailableFreeSpace` factors in disk quotas. This means that it is possible for the Drive to have space, but the **user may have exhausted their quota**. In which case, `AvailableFreeSpace` is probably what you mean to use if the current user intends to write some data.

### TLDR

**The `AvailableFreeSpace` property returns the actual amount of space the current user can write to, factoring in disk space and user quotas.**

**Happy hacking!**
