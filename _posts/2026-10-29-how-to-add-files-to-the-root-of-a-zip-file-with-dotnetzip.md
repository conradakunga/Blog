---
layout: post
title: How To Add Files To The Root Of A Zip File With DotNetZip
date: 2026-10-29 15:34:39 +0300
categories:
    - C#
    - .NET
---

I was recently overhauling some code to add a new requirement to **generate** some files, **process** them, and add them to the root of the [Zip](https://en.wikipedia.org/wiki/ZIP_(file_format)) file.

This is something we have talked about before on the post "[How To Zip Multiple Files In C# & .NET]({% post_url 2026-01-07-how-to-zip-multiple-files-in-c-net %})"

However the caveat here is that this is **already written codebase** that is using the [DotNetZip](https://www.nuget.org/packages/DotNetZip.Original/) library, and therefore replacing that with [System.IO.Compression](https://learn.microsoft.com/en-us/dotnet/api/system.io.compression?view=net-10.0) is not an option.

The initial code was as follows:

```c#
var files = Directory.GetFiles(rootFolder);

var zipFile = Path.Combine("/Users/Rad/Target", $"Generated.zip");

using (var zip = new ZipFile())
{
  zip.AddFiles(files);
  zip.Save(zipFile);
}
```

The magic is taking place here:

```c#
zip.AddFiles(files);
```

This will add files to the `Zip` and preserve their existing hierarchy.

If you don't want this, i.e. you want to add them to the **root**, use this overload:

```c#
zip.AddFiles(files, "");
```

This will add the files to the **root** level of `the` Zip file.

### TLDR

**To add files to the root of a `Zip` file without hierarchy, i.e. in the root, use the overload `zip.AddFiles(files, "");`**

Happy hacking!
