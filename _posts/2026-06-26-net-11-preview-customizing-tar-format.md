---
layout: post
title: .NET 11 Preview - Customizing Tar Format
date: 2026-06-26 22:54:41 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
    - Compression
---

In a previous post, "[How To Compress Multiple Files Using GZip In C# & .NET]({% post_url 2026-01-12-how-to-compress-multiple-files-using-gzip-in-c-net %})", we looked at how to **compress multiple files** using [gzip](https://en.wikipedia.org/wiki/Gzip) compression, during which we observed that it is **not in fact possible to compress multiple files using `gzip`**, as it only supports a **single** file.

Therefore to compress the files you need to process them into an **intermediate** format that is a single file, the [tar](https://en.wikipedia.org/wiki/Tar_(computing)).

What you may not realize that there are in fact **multiple types** of `tar`:

- [Pax](https://en.wikipedia.org/wiki/Tar_(computing)#POSIX.1-2001/pax)
- [Ustar](https://en.wikipedia.org/wiki/Tar_(computing)#UStar_format)
- [GNU](https://en.wikipedia.org/wiki/Tar_(computing)#cite_note-gnu.org-17)
- [v7](https://en.wikipedia.org/wiki/Tar_(computing)#Header)

In **.NET 10**, you always got the `Pax` format, given there was no way to specify a format.

The code was as follows:

```c#
await TarFile.CreateFromDirectoryAsync("/source/", "/target/archive.tar",
    includeBaseDirectory: true);
```

**In .NET 11**, you can specify the **format that you want** using the new overload for [CreateFromDirectory](https://learn.microsoft.com/en-us/dotnet/api/system.formats.tar.tarfile.createfromdirectory) and [CreateFromDirectoryAsync](https://learn.microsoft.com/en-us/dotnet/api/system.formats.tar.tarfile.createfromdirectoryasync), specifying the format that you want with the `format` parameter that takes a [TarEntryFormat](https://learn.microsoft.com/en-us/dotnet/api/system.formats.tar.tarentryformat?view=net-11.0) enum.

| Name    | Value | Description                                                  |
| ------- | ----- | ------------------------------------------------------------ |
| Unknown | 0     | Tar entry format undetermined.                               |
| V7      | 1     | 1979 Version 7 AT&T Unix tar entry format.                   |
| Ustar   | 2     | POSIX IEEE 1003.1-1988 Unix Standard tar entry format.       |
| Pax     | 3     | POSIX IEEE 1003.1-2001 ("POSIX.1") Pax Interchange tar entry format. |
| Gnu     | 4     | GNU tar entry format (gnu).                                  |

Your code would this look like this:

```c#
await TarFile.CreateFromDirectoryAsync("/source/", "/target/archive.tar",
    includeBaseDirectory: true, format: TarEntryFormat.Gnu);
```

### TLDR

**When creating `tar` archives, you can now specify the *format* in .NET 11.**

Happy hacking!
