---
layout: post
title: .NET 11 Preview - Stream Adapters
date: 2026-07-16 21:00:48 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

Quite a number of .NET APIs take [streams](https://learn.microsoft.com/en-us/dotnet/api/system.io.stream?view=net-10.0) as parameters.

However, you will typically run into a challenge where your data is not a `stream`, and you will typically need to do some **gymnastics** to **convert** it into one.

Take this example:

```c#
// Get our data
var data =
"""
The quick brown fox
mightily jumped over
the brown dog very
very bigly
""";

// Convert our data a byte array
var dataInBytes = Encoding.Default.GetBytes(data);

// Convert our byte array into a memory stream
var dataStream = new MemoryStream(dataInBytes);
```

You will see here that we need to create an intermediate [byte](https://learn.microsoft.com/en-us/dotnet/api/system.byte?view=net-10.0) [array](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/arrays), and then convert that into a `stream`.

This is such a common use case that .NET 11 now has a solution to this: the `StringStream`. (**As I write this, the official API documentation is yet to be updated, for Preview 6)**

Our code above can be rewritten as follows:

```c#
// Directly create a stream
var directDataStream = new StringStream(data, Encoding.UTF8);
```

Of importance here is that you have to specify the [encoding](https://en.wikipedia.org/wiki/Character_encoding) of your `string`, which is typically [UTF8](https://en.wikipedia.org/wiki/UTF-8). Unless you really know what you're doing, specify [Encoding.UTF8](https://learn.microsoft.com/en-us/dotnet/api/system.text.encoding.utf8?view=net-10.0).

### TLDR

**.NET 11 has new APIs, such as the `StringStream`, that allow you to directly create `Streams` from text.**

The code is in my GitHub.

Happy hacking!
