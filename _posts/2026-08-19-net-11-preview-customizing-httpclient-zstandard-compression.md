---
layout: post
title: .NET 11 Preview - Customizing HttpClient Zstandard Compression
date: 2026-08-19 19:06:51 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
    - Compression
---

In our previous post, "[.NET 11 Preview - Using ZStandard Compression With A HttpClient]({% post_url 2026-08-18-net-11-preview-using-zstandard-compression-with-a-httpclient %})", we looked at how to use [ZStandard](http://facebook.github.io/zstd/) to **compress outbound traffic** to a web server.

Given this type:

```c#
public class Spy
{
  public required string Firstname { get; set; }
  public required string Surname { get; set; }
  public required string Agency { get; set; }
  public required DateOnly DateOfBirth { get; set; }
  public required DateOnly HireDate { get; set; }
}
```

This is how we create an instance:

```c#
var jamesBond = new Spy
{
  Firstname = "James",
  Surname = "Bond",
  Agency = "MI-6",
  DateOfBirth = new DateOnly(1950, 1, 1),
  HireDate = new DateOnly(1975, 1, 1,)
};
```

This is how we compress it:

```c#
// Create the payload
var payload = JsonContent.Create(jamesBond);
// Create a HttpRequest
using var request = new HttpRequestMessage(HttpMethod.Post, API_URL);
// Compress the content
request.Content = new ZstandardCompressedContent(payload, CompressionLevel.SmallestSize);
//Post
await client.SendAsync(request);
```

The magic is in this line:

```c#
request.Content = new ZstandardCompressedContent(payload, CompressionLevel.SmallestSize);
```

Here, we want the smallest possible size.

Suppose we wanted to customize more? It is possible to customize a whole host of options using the overloaded constructor that takes a [ZstandardCompressionOptions](https://learn.microsoft.com/en-us/dotnet/api/system.io.compression.zstandardcompressionoptions?view=net-11.0)

The code is as follows:

```c#
// Create the payload
var payload = JsonContent.Create(jamesBond);
// Create a HttpRequest
using var request = new HttpRequestMessage(HttpMethod.Post, API_URL);
// Set-up compression options
var options = new ZstandardCompressionOptions
{
    Quality = 6,
    AppendChecksum = true,
    EnableLongDistanceMatching = false
};
// Compress the content
request.Content = new ZstandardCompressedContent(payload, options);
//Post
await client.SendAsync(request);
```

The properties you can set are as follows:

| Name  |
| ----- |
| AppendChecksum |
| Dictionary |
| EnableLongDistanceMatching |
| Quality |
| TargetBlockSize |
| WindowLog2 |

As of this writing, the class is **poorly documented,** and definitions of the properties are not forthcoming.

### TLDR

**You can customize `Zstandard` compression options for `HttpClient` compression.**

The code is in my GitHub.

Happy hacking!
