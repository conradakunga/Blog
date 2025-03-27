---
layout: post
title: Improving ASP.NET Content Negotiation XML Serialization Performance Using A RecyclableMemoryStream
date: 2025-03-21 16:11:47 +0300
categories:
    - ASP.NET
    - C#
    - XML
    - JSON
    - StarLibrary
    - Carter
---

In a [previous post]({% post_url 2025-03-17-conditionally-output-xml-or-json-using-aspnet-minimal-api %}), we looked at how to use **content negotiation** to have an API produce `XML` instead of `JSON` by writing a `ResponseNegotiator` class that implements the `IResponseNegotiator` interface from the [Carter](https://github.com/CarterCommunity/Carter) library.

For a **vast majority** of use cases, that implementation ought to suffice.

The implementation was as follows:

```c#
using System.Net.Mime;
using System.Runtime.Serialization;
using Carter;
using Microsoft.Net.Http.Headers;

public class XMLResponseNegotiator : IResponseNegotiator
{
    // Establish if the client had indicated it will accept xml
    public bool CanHandle(MediaTypeHeaderValue accept)
    {
        return accept.MatchesMediaType(MediaTypeNames.Application.Xml);
    }

    // Handle the request
    public async Task Handle<T>(HttpRequest req, HttpResponse res, T model, CancellationToken ct)
    {
        // Set the content type
        res.ContentType = MediaTypeNames.Application.Xml;

        // Create a serializer for the model type, T
        var serializer = new DataContractSerializer(typeof(T));

        // Create a memory stream
        using (var ms = new MemoryStream())
        {
            // Write the object
            serializer.WriteObject(ms, model);

            // Set the stream position to 0, for writing to the response
            ms.Position = 0;

            // Write the memory stream to the response Body
            await ms.CopyToAsync(res.Body, ct);
        }
    }
}
```

However, if you have a very **busy**  API making a lot of requests, one part of the code is a **potential performance problem**:

```c#
using (var ms = new MemoryStream())
{
    // Write the object
    serializer.WriteObject(ms, model);

    // Set the stream position to 0, for writing to the response
    ms.Position = 0;

    // Write the memory stream to the response Body
    await ms.CopyToAsync(res.Body, ct);
}
```

The challenge here is that the runtime can potentially allocate, write to, and release a lot of [MemoryStream](https://learn.microsoft.com/en-us/dotnet/api/system.io.memorystream?view=net-9.0) objects, which, under high load, can cause memory pressure on the server in terms of allocations, fragmentation, and garbage collection.

In this regard, we can use a library designed for this scenario - the [RecyclableMemoryStream](https://github.com/microsoft/Microsoft.IO.RecyclableMemoryStream).

We add this to our project as follows:

```bash
dotnet add package Microsoft.IO.RecyclableMemoryStream
```

The next order of business is to create an instance of the `RecyclableMemoryStream` and have it available throughout the application.

One way to do this is to register a singleton.

```c#
builder.Services.AddSingleton<RecyclableMemoryStreamManager>();
```

We then update our `XmlResponseNegotiator` to inject this:

```c#
using System.Net.Mime;
using System.Runtime.Serialization;
using Carter;
using Microsoft.IO;
using Microsoft.Net.Http.Headers;

namespace XMLSerialization;

public sealed class XmlResponseNegotiator : IResponseNegotiator
{
    private readonly RecyclableMemoryStreamManager _streamManager;

    public XmlResponseNegotiator(RecyclableMemoryStreamManager streamManager)
    {
        _streamManager = streamManager;
    }

    // Establish if the client had indicated it will accept xml
    public bool CanHandle(MediaTypeHeaderValue accept)
    {
        return accept.MatchesMediaType(MediaTypeNames.Application.Xml);
    }

    // Handle the request
    public async Task Handle<T>(HttpRequest req, HttpResponse res, T model, CancellationToken ct)
    {
        // Set the content type
        res.ContentType = MediaTypeNames.Application.Xml;

        // Create a serializer for the model type, T
        var serializer = new DataContractSerializer(typeof(T));

        // Acquire the shared memory stream
        await using (var ms = _streamManager.GetStream())
        {
            // Write the object to the stream
            serializer.WriteObject(ms, model);

            // Set the stream position to 0, for writing to the response
            ms.Position = 0;

            // Write the memory stream to the response Body
            await ms.CopyToAsync(res.Body, ct);
        }
    }
}
```

As you can see, it is almost a seamless replacement for the [MemoryStream](https://learn.microsoft.com/en-us/dotnet/api/system.io.memorystream?view=net-9.0) class, as the `GetStream()` method returns a `RecyclableMemoryStream`.

You can fine-tune performance even further by configuring the steam as follows (these are just example values - adjust as needed fo your use case):

```c#
var options = new RecyclableMemoryStreamManager.Options()
{
    BlockSize = 1024,
    LargeBufferMultiple = 1024 * 1024,
    MaximumBufferSize = 16 * 1024 * 1024,
    GenerateCallStacks = true,
    AggressiveBufferReturn = true,
    MaximumLargePoolFreeBytes = 16 * 1024 * 1024 * 4,
    MaximumSmallPoolFreeBytes = 100 * 1024,
};

var manager = new RecyclableMemoryStreamManager(options);
```

Details of these options are available in the [documentation](https://github.com/microsoft/Microsoft.IO.RecyclableMemoryStream).

### TLDR

**The `RecyclableMemoryStream` is a drop-in replacement for the `MemoryStream` in cases where you are potentially creating many `MemoryStream` objects  and want to optimize memory allocations and garbage collections.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-03-21%20-%20XML%20Performance).

Happy hacking!
