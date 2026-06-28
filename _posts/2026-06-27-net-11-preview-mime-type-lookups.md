---
layout: post
title: .NET 11 Preview - MIME Type Lookups
date: 2026-06-27 21:45:47 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

In. previous post, "[Use Constants For MIME Types]({% post_url 2026-06-01-tip-use-constants-for-mime-types %})", we discussed how to avoid specifying strings for [MIME](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/MIME_types) types and use  built in **constants** instead.

The problem with this is that you needed to know the `MIME` type **in advance**, making the code a lot more **complicated** when you don't.

You would typically need to write a giant [switch](https://www.w3schools.com/cs/cs_switch.php) statement like so:

```c#
var extension = "";
var mimeType = "";
switch (extension)
{
  case ".pdf":
    mimeType = "applciation/pdf";
    break;
  //
  // Other types here
  //
  default:
    mimeType = "text/plain";
    break;
}
```

Alternatively, you had to use a third party Nuget package.

This is now addressed with the new [MediaTypeMap](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypemap?view=net-11.0) class.

You use it as follows:

```c#
var mediaType = MediaTypeMap.GetMediaType(".txt");
Console.WriteLine(mediaType);
```

This will print the following:

```plaintet
text/plain
```

A few more examples

```c#
// PDF
var mediaType = MediaTypeMap.GetMediaType(".pdf");
Console.WriteLine(mediaType);
// MP4
mediaType = MediaTypeMap.GetMediaType(".mp4");
Console.WriteLine(mediaType);
// Excel
mediaType = MediaTypeMap.GetMediaType(".xlsx");
Console.WriteLine(mediaType);
//Unknown
mediaType = MediaTypeMap.GetMediaType(".dsf");
Console.WriteLine(mediaType);
```

These will return the following:

![mimeResults](../images/2026/06/mimeResults.png)

Of interest here is if the file type is **unknown**, a `null` will be returned. This you can test for in your code.

### TLDR

**The `MediaTypeMap` class in [System.Net.Mime.MediaTypeMap]() can be used to get MIME types from extensions.**

Happy hacking!
