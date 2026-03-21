---
layout: post
title: Creating Other Archive Types Using 7-Zip Command Line In C# & .NET
date: 2026-02-01 14:16:37 +0300
categories:
    - C#
    - .NET
    - Compression
---

Over the past series of posts, we have looked at how to use the [7-Zip](https://en.wikipedia.org/wiki/7z) command line to create `7z` archives.

What you might not know is that the `7-Zip` command-line tool natively supports the **creation** of the following archive types:

1. [7z](https://en.wikipedia.org/wiki/7z)
2. [BZip2](https://en.wikipedia.org/wiki/Bzip2)
3. [GZIP](https://en.wikipedia.org/wiki/Gzip)
4. [TAR](https://en.wikipedia.org/wiki/Tar_(computing))
5. [WIM](https://en.wikipedia.org/wiki/Windows_Imaging_Format)
6. [XZ](https://en.wikipedia.org/wiki/XZ_Utils)

It also supports the extraction of a number of formats:

1. APM
2. AR
3. ARJ
4. CAB
5. CHM
6. COMPOUND
7. CPIO
8. CramFS
9. DMG
10. Ext
11. FAT
12. HFS
13. HXS
14. iHEX
15. ISO
16. LZH
17. LZMA
18. MBR
19. MsLZ
20. Mub
21. NSIS
22. NTFS
23. MBR
24. RAR
25. RPM
26. PPMD
27. QCOW2
28. SPLIT
29. SquashFS
30. UDF
31. UEFIc
32. UEFIs
33. VDI
34. VHD
35. VMDK
36. XAR
37. Z

All of this can be leveraged in our code by automating the `7-Zip` command-line utility.

The **general format** to **create** archives would look like this:

```c#
var result = await Cli.Wrap(executablePath) // Set the path to the executable
    .WithArguments(args => args
            .Add("a") //Specify to create an archive
            .Add("-t{INSERT FORMAT HERE}") // Specify the target format
            .Add(targetArchiveWithFolder) // Target file name
```

Remember, some formats only support adding a **single file** - `TAR`, `BZip2`, `Gzip`, `xz`

The **general format** to **extract** archives would look like this:

```c#
var result = await Cli.Wrap(executablePath) // Set the path to the executable
    .WithArguments(args => args
            .Add("x") //Specify to extract an archive
            .Add(sourceArchiveFile) // Source archive file
            .Add($"-o{INSERT OUTPUT FOLDER HERE}") // The output folder
```

### TLDR

**The 7-Zip command line utility can create and extract a number of archive formats.**

Happy hacking!
