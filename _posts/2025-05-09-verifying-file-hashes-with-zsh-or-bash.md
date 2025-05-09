---
layout: post
title: Verifying File Hashes With Zsh or Bash
date: 2025-05-09 21:18:37 +0300
categories:
    - Shell
---

In a previous post, I discussed verifying file hashes using PowerShell. Now that PowerShell is cross-platform, this means it will work on any operating system that supports it, particularly the usual suspects—Windows, Linux, and macOS.

However, what are your options if you don't have access to PowerShell?

The default shells on Linux and macOS support this via the [shasum](https://linux.die.net/man/1/shasum) command.

Let us again use our example, the utility [HandBrake](https://handbrake.fr/).

To verify the `SHA-265` checksum, we would do it as follows:

```bash
shasum -a 256 HandBrake-1.9.2.dmg
```

The `-a` allows you to specify an algorithm.

You should get the following output:

![shasum256](../images/2025/05/shasum256.png)

The available options are

| Parameter | Algorithm |
| --------- | --------- |
| 1         | SHA-1     |
| 224       | SHA-224   |
| 256       | SHA-265   |
| 384       | SHA-384   |
| 512       | SHA-512   |

If you don't specify an algorithm, `SHA-1` will be used.

![shasum](../images/2025/05/shasum.png)

### TLDR

**The `shasum` command allows for the generation of checksums using various algorithms on *bash* and *zsh* shells**

Happy hacking!
