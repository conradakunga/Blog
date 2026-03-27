---
layout: post
title: How To Serialize Images To JSON Using A JsonConverter In C# & .NET C# & .NET
date: 2026-02-11 22:03:07 +0300
categories:
    - C#
    - .NET
    - Images
    - Json
---

In our previous post, "[How To Serialize Images To JSON In C# & .NET]({% post_url 2026-02-10-how-to-serialize-images-to-json-in-c-net %})", we looked at the **pitfalls** of serializing a type that has an `Image` property.

We saw that it was **not directly possible**, and solved the problem using an intermediate `DTO`.

However, I kept from you that **it is indeed possible to natively handle serialization of `Images`** (or almost any type) using the power of the [JsonConverter](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.serialization.jsonconverter-1?view=net-10.0). We have seen how to use these in the post "[Advanced Custom Deserialization With EasyNetQ Version 8 In C# & .NET]({% post_url 2026-02-09-advanced-custom-deserialization-with-easynetq-version-8-in-c-net %})" and "[Writing A Custom DateOnly JSON Deserializer]({% post_url 2022-12-13-writing-a-custom-dateonly-json-deserializer %})".

As a reminder, here is the `type` in question.

```c#
using SixLabors.ImageSharp;

namespace ImageSerialization;

public sealed record Movie
{
    public required string Title { get; init; }
    public required int Length { get; init; }
    public required DateOnly ReleaseDate { get; init; }
    public required Image Poster { get; init; }
}
```

Image, at least the one from [System.Drawing](https://learn.microsoft.com/en-us/dotnet/api/system.drawing?view=net-10.0), is **windows-specifi**c.

We solve this problem by using a **cross-platform** library,

In this case, we will use [SixLabors](https://sixlabors.com/) [ImageSharp](https://sixlabors.com/products/imagesharp/).

```bash
dotnet add package SixLabors.ImageSharp
```

Next, we write the `JsonConverter`.

```c#
using System.Text.Json;
using System.Text.Json.Serialization;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.Formats.Jpeg;
using SixLabors.ImageSharp.PixelFormats;

namespace ImageSerialization;

/// <summary>
/// A JsonConverter that handles Image Serialization 
/// </summary>
public class ImageJsonConverter : JsonConverter<Image>
{
    public override Image? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        // This is the deserialization process. Read the data as a stream of bytes
        return Image.Load<Rgba32>(reader.GetBytesFromBase64());
    }

    public override void Write(Utf8JsonWriter writer, Image value, JsonSerializerOptions options)
    {
        // This is the serialization process. Obtain the bytes of the image and write them as a stream
        using (var ms = new MemoryStream())
        {
            value.Save(ms, new JpegEncoder());
            writer.WriteBase64StringValue(ms.ToArray());
        }
    }
}
```

Finally, we wire it into our [JsonSerializationOptions](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializeroptions?view=net-10.0) to be used at serialization and deserialization points.

```c#
using System.Text.Json;
using ImageSerialization;
using Serilog;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();

// Create our movie
var movie = new Movie
{
    Title = "The Old Woman With The Knife",
    Length = 183,
    ReleaseDate = new DateOnly(2025, 5, 1),
    Poster = Image.Load<Rgba32>("movie.jpeg")
};

var options = new JsonSerializerOptions();
// Register our converter
options.Converters.Add(new ImageJsonConverter());

// Serialize for transfer
var json = JsonSerializer.Serialize(movie, options);

// Deserialize for processing (assume this is a different system)
var receivedMovie = JsonSerializer.Deserialize<Movie>(json, options)!;

// Use our movie here
Log.Information("The poster for {MovieTitle} measures {BoundsWidth} x  {BoundsHeight}",
    receivedMovie.Title, receivedMovie.Poster.Bounds.Width, receivedMovie.Poster.Bounds.Height);
```

The beauty of this approach is that:

1. It is **simpler**
2. You do not need to **change** your existing `types`, or add any new ones
3. You can control **any aspect** of the **serialization/deserialization** process

If we run this code, we should see the following:

```plaintext
[22:09:53 INF] The poster for The Old Woman With The Knife measures 459 x  680
```

### TLDR

**You can use `JsonConverters` to natively serialize complex types like `Image` objects.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-02-11%20-%20ImageSerialization).

Happy hacking!
