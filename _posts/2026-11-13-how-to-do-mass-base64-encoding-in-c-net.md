---
layout: post
title: How to do Mass Base64 Encoding In C# & .NET
date: 2026-11-13 14:25:15 +0300
categories:
    - C#
    - .NET
---

In a previous post, "[How to Encode Base64 Data In C# & .NET]({% post_url 2026-11-10-how-to-encode-base64-data-in-c-net %})", we looked at various ways to **encode** data using the [Base64](https://en.wikipedia.org/wiki/Base64) protocol.

This generally works fine when you have **small amounts of data** to encode, or the encoding is not in a **critical path** in your application.

When you have **large amounts of data**, or you want to encode **data that might not fit in memory at once**, you need a different approach - you need to use [streams](https://dev.to/lpl212757/c-streams-explained-with-real-life-analogies-2pob), and in particular, the [CryptoStream](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.cryptostream?view=net-10.0). We then use the [ToBase64Transform](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.tobase64transform?view=net-10.0) `class` to perform the encoding.

The code is as follows:

```c#
using System.Security.Cryptography;
using System.Text;

byte[] rawData = Encoding.UTF8.GetBytes("This is a dummy representing a large amount of text to Base64 encode. Quite a lot of data");

using (var inputStream = new MemoryStream(rawData))
{
  using (var outputStream = new MemoryStream())
  {
    using (var transform = new ToBase64Transform())
    {
      using (var cryptoStream = new CryptoStream(outputStream, transform, CryptoStreamMode.Write, leaveOpen: true))
      {
        inputStream.CopyTo(cryptoStream);
        // Important to flush the last bytes and add padding
        cryptoStream.FlushFinalBlock();
      }
    }
    // Fetch our data from the output stream
    var base64Result = Encoding.ASCII.GetString(outputStream.ToArray());
    Console.WriteLine(base64Result); //
  }
}
```

If the data was in a **file**, and we want the **encoded data in a second file**, we can rewrite the code like this:

```c#
using (var inputStream = File.OpenRead("VeryLargeFileForEncoding.txt"))
{
  using (var outputStream = File.Create("EncodedFile"))
  {
    using (var transform = new ToBase64Transform())
    {
      using (var cryptoStream = new CryptoStream(outputStream, transform, CryptoStreamMode.Write))
      {
        inputStream.CopyTo(cryptoStream);
        cryptoStream.FlushFinalBlock();
      }
    }
  }
}
```

This is much more **memory efficient**, and removes the need for **intermediate buffers** for processing.

If the data we want to encode is in a file, and we want the encoded string available immediately, this would be the way to go:

```c#
var rawData = File.ReadAllBytes("SmallOrMediumFile.txt");
var base64Result = Convert.ToBase64String(rawData);
Console.WriteLine(base64Result);
```

### TLDR

**There are `Stream` based `classes` that can help encoding large amounts of data.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-11-13%20-%20DefaultEncoding).

Happy hacking!
