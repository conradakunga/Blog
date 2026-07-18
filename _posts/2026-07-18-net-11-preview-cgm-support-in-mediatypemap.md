---
layout: post
title: .NET 11 Preview - CGM Support in MediaTypeMap
date: 2026-07-18 20:39:04 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

In a previous post, [.NET 11 Preview - MIME Type Lookups]({% post_url 2026-06-27-net-11-preview-mime-type-lookups %}), we looked at the new [MediaTypeMap](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypemap?view=net-11.0) `class` that allows us to fetch [MIME Types](https://en.wikipedia.org/wiki/MIME) from **file extensions** natively in .NET without requiring **third-party libraries**.

This has further been updated to support a lesser-used but very common format in technical circles - [Computer Graphics](https://en.wikipedia.org/wiki/Computer_Graphics_Metafile) metafile, `.cgm`, standardized in [ISO 8632-1](https://www.iso.org/standard/32378.html).

This means that this code:

```c#
Console.WriteLine(MediaTypeMap.GetMediaType("cgm"));
```

Will print the following:

![mediaTypeFromExtension](../images/2026/07/mediaTypeFromExtension.png)

Correspondingly, we can get the **extension** from the **name**, like so:

```c#
Console.WriteLine(MediaTypeMap.GetExtension("image/cgm"));
```

This will print the following:

![mediaTypeNameFromExtension](../images/2026/07/mediaTypeNameFromExtension.png)

### TLDR

**Computer Graphics Metafile support has been added to the `MediaTypeMap` class.**

Happy hacking!
