---
layout: post
title: Correctly Setting HttpClient BaseAddress
date: 2024-03-17 18:30:24 +0300
categories:
    - .NET
    - C#
    - HttpClient
---
To make [HTTP](https://en.wikipedia.org/wiki/HTTP) requests in C# (or any other .NET language), you use the [HttpClient](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient?view=net-8.0) class.

For example, if I wanted to retrieve the text of the [About](https://www.conradakunga.com/blog/about/) page of this blog, as well as the [Archives](https://www.conradakunga.com/blog/archives/), I would do it as follows:

```csharp
var client = new HttpClient();
// Get the about page
var about = await client.GetStringAsync("https://www.conradakunga.com/blog/about/");
// Get the archive page
var archive = await client.GetStringAsync("https://www.conradakunga.com/blog/archives/");
```

If you look closely, you will see that I am always repeating the same bit - [https://www.conradakunga.com/blog/](https://www.conradakunga.com/blog/)

Is it possible to avoid this repetition? Absolutely.

You do so by setting the [BaseAddress](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient.baseaddress?view=net-8.0) property of the `HttpClient`

```csharp
var client = new HttpClient()
{
    // Set the base address URI
    BaseAddress = new Uri("https://www.conradakunga.com/blog/")
};
// Get the about page
var about = await client.GetStringAsync("about");
// Get the archive page
var archive = await client.GetStringAsync("archives");
```

Of not here is that the `BaseAddress` is a [URI](https://learn.microsoft.com/en-us/dotnet/api/system.uri?view=net-8.0), and not a string.

Also, **you must have the trailing slash**, `/` at the end of the `BaseAddress`.

In other words, the following will not work

```csharp
var client = new HttpClient()
{
    // Set the base address URI - this will fail
    BaseAddress = new Uri("https://www.conradakunga.com/blog")
};
```

You must also **NOT** have a leading slash, `/` at the start of the request.

In other words, the following will not work:

```csharp
var client = new HttpClient()
{
    // Set the base address URI
    BaseAddress = new Uri("https://www.conradakunga.com/blog/")
};
// Get the about page - this will fail!
var about = await client.GetStringAsync("/about");
```

This behaviour is consistent with the RFC for [Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986)

In summary, **you must place a trailing slash at the end of the BaseAddress but must NOT have a leading slash at the beginning of the request**.

Happy hacking!