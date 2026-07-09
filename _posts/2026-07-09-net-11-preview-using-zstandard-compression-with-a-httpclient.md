---
layout: post
title: .NET 11 Preview - Using Zstandard Compression With A HttpClient
date: 2026-07-09 22:59:58 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

Yesterday's post, "[NET 11 Preview - Zstandard Compression]({% post_url 2026-07-08-net-11-preview-zstandard-compression %})", looked at the introduction of the [Zstandard](https://en.wikipedia.org/wiki/Zstd) algorithm into the compression libraries in [System.IO.Compression](https://learn.microsoft.com/en-us/dotnet/api/system.io.compression?view=net-10.0) namespace.

In today's post, we will look at how to use `Zstandard` compression with a [HttpClient](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient?view=net-10.0).

For this, we first write a [HttpClientHandler](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclienthandler?view=net-10.0) like so:

```c#
var handler = new HttpClientHandler
{
  AutomaticDecompression = DecompressionMethods.Zstandard
};
```

Here, we are setting the [AutomaticDecompression](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclienthandler.automaticdecompression?view=net-11.0) property.

It is generally a good idea to specify an **alternate** compression if the web server does not support `Zstandard`, like so:

```c#
var handler = new HttpClientHandler
	{
		AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Zstandard
	};
```

Here, we are specifying `GZip` or `Zstandard`.

Finally, we wire up and use our `HttpClient`.

```c#
var handler = new HttpClientHandler
{
  AutomaticDecompression = DecompressionMethods.Zstandard
};

var client = new HttpClient(handler);
var response = await client.GetStringAsync("https://facebook.com");

Console.WriteLine(response.Length);
```

We are using **Facebook** here because the server already supports `Zstandard`.

### TLDR

**You can utilize `Zstandard` compression with a `HttpClient` by wrapping it in a `HttpClientHandler`.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-07-09%20-%20ZStandardHttpClient).

Happy hacking!
