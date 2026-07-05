---
layout: post
title: .NET 11 Preview - Video MIME Type Constants
date: 2026-06-30 23:30:41 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

In a previous post, "[Tip - Use Constants For MIME Types]({% post_url 2026-06-01-tip-use-constants-for-mime-types %})", we discussed how to use **constants** for [MIME](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/MIME_types) types, rather than the usual approach of specifying them as `strings`.

Thus, instead of doing this:

```c#
const string ApplicationJSON = "application/json";
```

You do this:

```c#
const string ApplicationJSON = MediaTypeNames.Application.Json;
```

This extends to other types of content:

- [Application](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.application?view=net-10.0)
- [Font](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.font?view=net-10.0)
- [Image](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.image?view=net-10.0)
- [Multipart](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.multipart?view=net-10.0)
- [Text](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.text?view=net-10.0)

One glaring omission is that **video is not represented** at all.

This is fixed in .NET 11 in the [MediaTypeNames.Video](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.video?view=net-11.0) class, which exposes the following [constants](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/constants):

- [Mp4](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.video.mp4?view=net-11.0#system-net-mime-mediatypenames-video-mp4) 
- [Mpeg](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.video.mpeg?view=net-11.0#system-net-mime-mediatypenames-video-mpeg) 
- [Ogg](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.video.ogg?view=net-11.0#system-net-mime-mediatypenames-video-ogg) 
- [QuickTime](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.video.quicktime?view=net-11.0#system-net-mime-mediatypenames-video-quicktime) 
- [WebM](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.video.webm?view=net-11.0#system-net-mime-mediatypenames-video-webm) 

### TLDR

**The [MediaTypeNames.Video](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.video?view=net-11.0) contains MIME constants for the major video formats.**

Happy hacking!
