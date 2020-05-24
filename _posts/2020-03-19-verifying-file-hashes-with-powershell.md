---
id: 41
title: Verifying File Hashes With PowerShell
date: 2020-03-19T12:10:26+03:00
author: Conrad Akunga
layout: post
guid: https://www.conradakunga.com/blog/?p=41
permalink: /2020/03/19/verifying-file-hashes-with-powershell/
categories:
  - PowerShell
---
It is often a good idea to verify the file hashes of downloaded files, whether it is to detect that the file you download was actually the one that the developers intended ([see what happened to Handbrake for OSX)](https://www.extremetech.com/computing/249070-handbrake-download-mirror-compromised-macos-malware) or to detect corruption of a download.

Normally on Windows you’d have to download one of the many hashing programs available online.

But did you know that PowerShell can compute hashes for you?

This is done using the Get-FileHash cmdlet.

Which works like so…

```powershell
Get-FileHash <filename>
```

![](images/2020/03/Hash.png)

But what if you want the MD5 hash?

No problem

![](images/2020/03/Hash-2.png)

These are the supported algorithms

  * MD5
  * SHA1
  * RIPEMD160
  * MACTripleDES
  * SHA256
  * SHA384
  * SHA512

The first two are fully supported for legacy reasons.

Happy hacking!