---
layout: post
title: .NET 11 Preview - Get Extension From MIME Type
date: 2026-06-28 22:08:39 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
    - MIME
---

Yesterday's post, "[.NET 11 Preview - MIME Type Lookups]({% post_url 2026-06-27-net-11-preview-mime-type-lookups %})", looked at how to get the [MIME](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/MIME_types) type of a file given its **extension** using the new [MediaTypeMap](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypemap?view=net-11.0) `class`.

In today's post, we look at the **opposite** problem - how to get the **extension** given the `MIME` **type**.

This is also addressed using the [MediaTypeMap](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypemap?view=net-11.0) class, via the [GetExtension](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypemap.getextension?view=net-11.0) method.

The code is as follows:

```c#
var extension = MediaTypeMap.GetExtension("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
Console.WriteLine(extension);
```

This will return the following:

```plantext
.xlsx
```

In the event the `MIME` type is **unknown**, `null` is returned.

![mimeExtension](../images/2026/06/mimeExtension.png)

### TLDR

**The `MediaTypeMap` class has a `GetExtension` method that gets the extension of a given `MIME` type.**

Happy hacking!
