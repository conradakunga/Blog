---
layout: post
title: .NET 11 Preview - Using ZStandard Compression With A HttpClient
date: 2026-08-18 18:23:00 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
    - Compression
---

In a previous post, "[.NET 11 Preview - Using Zstandard Decompression With A HttpClient]({% post_url 2026-07-09-net-11-preview-using-zstandard-decompression-with-a-httpclient %})", we looked at how to configure a [HttpClient](https://learn.microsoft.com/en-us/dotnet/fundamentals/networking/http/httpclient) to **transparently decompress traffic** compressed using the [Zstandard](http://facebook.github.io/zstd/) algorithm.

In this post, we will look at the **opposite**: how to compress **outbound** traffic with `Zstandard`.

Suppose we had this `type`:

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

And this instance:

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

Suppose we needed to send this to an API.

We would typically do it like this:

```c#
var client = new HttpClient();
await client.PostAsJsonAsync("https://reqbin.com/echo/post/json", jamesBond);
```

Here I am using the API testing siite https://reqbin.com/.

To compress this, we need to do some **additional work**.

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

Here we are doing the following:

1. Creating a [JsonContent](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.json.jsoncontent?view=net-11.0-pp) object from our `Spy` `type`
2. Creating a [POST](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Methods/POST) [HttpRequestMessage](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httprequestmessage?view=net-10.0)
3. **Compressing** the content
4. Sending the `HttpRequestMessage`

### TLDR

**.NET 11 allows you to use `Zstandard` to compress traffic to a destination server from a `HttpClient`.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-08-17%20-%20CompressZStandard).

Happy hacking!
