---
layout: post
title: How To Serialize Images To JSON In C# & .NET
date: 2026-02-10 21:18:10 +0300
categories:
    - C#
    - .NET
    - Images
    - Json
---

[JSON](https://en.wikipedia.org/wiki/JSON) is pretty much the **de facto standard** for moving data **between systems**, which works across **operating systems** and **programming languages**.

This, however, lends it to **abuse**, where it is used in scenarios that stretch the imagination.

Recently, I was updating some old code and found a `class` that looked like this (***exact definition has been camouflaged to protect the guilty***).

```c#
public sealed class Movie
{
    public required string Title { get; init; }
    public required int Length { get; init; }
    public required DateOnly ReleaseDate { get; init; }
    public required Image Poster { get; init; }
}
```

A request has been made to **serialize** this as `JSON` for consumption by an **external system**.

This presents a number of problems:

1. `Image` is not a **cross-platform** type
2. `Image` is not **serializable**

The code in the wild worked like this:

```c#
var movie = new Movie
{
    Title = "The Old Woman With The Knife",
    Length = 183,
    ReleaseDate = new DateOnly(2025, 5, 1),
    Poster = Image.Load<Rgba32>("movie.jpeg")
};

// Do things with the movie here
```

Here, [Image.Load](https://docs.sixlabors.com/api/ImageSharp/SixLabors.ImageSharp.Image.html#SixLabors_ImageSharp_Image_Load_SixLabors_ImageSharp_Formats_DecoderOptions_System_IO_Stream_) is from the excellent [SixLabors](https://sixlabors.com/) [ImageSharp](https://sixlabors.com/products/imagesharp/) library, which is cross-platform.

You might be tempted to try something like this:

```c#
var json = JsonSerializer.Serialize(movie);
```

This will unceremoniously throw an [exception](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/exceptions/):

```plaintext
Unhandled exception. System.InvalidOperationException: The type 'System.ReadOnlySpan`1[System.Byte]' of property 'Preamble' on type 'System.Text.Encoding' is invalid for serialization or deserialization because it is a pointer type, is a ref struct, or contains generic parameters that have not been replaced by specific types.
   at System.Text.Json.ThrowHelper.ThrowInvalidOperationException_CannotSerializeInvalidType(Type typeToConvert, Type declaringType, MemberInfo memberInfo)
   at System.Text.Json.Serialization.Metadata.DefaultJsonTypeInfoResolver.CreatePropertyInfo(JsonTypeInfo typeInfo, Type typeToConvert, MemberInfo memberInfo, NullabilityInfoContext nullabilityCtx, JsonSerializerOptions options, Boolean shouldCheckForRequiredKeyword, Boolean hasJsonIncludeAttribute)
   at System.Text.Json.Serialization.Metadata.DefaultJsonTypeInfoResolver.AddMembersDeclaredBySuperType(JsonTypeInfo typeInfo, Type currentType, NullabilityInfoContext nullabilityCtx, Boolean constructorHasSetsRequiredMembersAttribute, PropertyHierarchyResolutionState& state)
   at System.Text.Json.Serialization.Metadata.DefaultJsonTypeInfoResolver.PopulateProperties(JsonTypeInfo typeInfo, NullabilityInfoContext nullabilityCtx)
   at System.Text.Json.Serialization.Metadata.DefaultJsonTypeInfoResolver.CreateTypeInfoCore(Type type, JsonConverter converter, JsonSerializerOptions options)
   at System.Text.Json.Serialization.Metadata.DefaultJsonTypeInfoResolver.GetTypeInfo(Type type, JsonSerializerOptions options)
   at System.Text.Json.JsonSerializerOptions.GetTypeInfoNoCaching(Type type)
   at System.Text.Json.JsonSerializerOptions.CachingContext.CreateCacheEntry(Type type, CachingContext context)
--- End of stack trace from previous location ---
   at System.Text.Json.JsonSerializerOptions.CachingContext.CacheEntry.GetResult()
   at System.Text.Json.JsonSerializerOptions.GetTypeInfoInternal(Type type, Boolean ensureConfigured, Nullable`1 ensureNotNull, Boolean resolveIfMutable, Boolean fallBackToNearestAncestorType)
   at System.Text.Json.Serialization.Metadata.JsonPropertyInfo.Configure()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.ConfigureProperties()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.Configure()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.<EnsureConfigured>g__ConfigureSynchronized|174_0()
   at System.Text.Json.JsonSerializerOptions.GetTypeInfoInternal(Type type, Boolean ensureConfigured, Nullable`1 ensureNotNull, Boolean resolveIfMutable, Boolean fallBackToNearestAncestorType)
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.Configure()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.<EnsureConfigured>g__ConfigureSynchronized|174_0()
   at System.Text.Json.JsonSerializerOptions.GetTypeInfoInternal(Type type, Boolean ensureConfigured, Nullable`1 ensureNotNull, Boolean resolveIfMutable, Boolean fallBackToNearestAncestorType)
   at System.Text.Json.Serialization.Metadata.JsonPropertyInfo.Configure()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.ConfigureProperties()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.Configure()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.<EnsureConfigured>g__ConfigureSynchronized|174_0()
   at System.Text.Json.JsonSerializerOptions.GetTypeInfoInternal(Type type, Boolean ensureConfigured, Nullable`1 ensureNotNull, Boolean resolveIfMutable, Boolean fallBackToNearestAncestorType)
   at System.Text.Json.Serialization.Metadata.JsonPropertyInfo.Configure()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.ConfigureProperties()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.Configure()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.<EnsureConfigured>g__ConfigureSynchronized|174_0()
   at System.Text.Json.JsonSerializerOptions.GetTypeInfoInternal(Type type, Boolean ensureConfigured, Nullable`1 ensureNotNull, Boolean resolveIfMutable, Boolean fallBackToNearestAncestorType)
   at System.Text.Json.Serialization.Metadata.JsonPropertyInfo.Configure()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.ConfigureProperties()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.Configure()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.<EnsureConfigured>g__ConfigureSynchronized|174_0()
   at System.Text.Json.JsonSerializerOptions.GetTypeInfoInternal(Type type, Boolean ensureConfigured, Nullable`1 ensureNotNull, Boolean resolveIfMutable, Boolean fallBackToNearestAncestorType)
   at System.Text.Json.Serialization.Metadata.JsonPropertyInfo.Configure()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.ConfigureProperties()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.Configure()
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo.<EnsureConfigured>g__ConfigureSynchronized|174_0()
   at System.Text.Json.JsonSerializerOptions.GetTypeInfoInternal(Type type, Boolean ensureConfigured, Nullable`1 ensureNotNull, Boolean resolveIfMutable, Boolean fallBackToNearestAncestorType)
   at System.Text.Json.JsonSerializerOptions.GetTypeInfoForRootType(Type type, Boolean fallBackToNearestAncestorType)
   at System.Text.Json.JsonSerializer.GetTypeInfo[T](JsonSerializerOptions options)
   at System.Text.Json.JsonSerializer.Serialize[TValue](TValue value, JsonSerializerOptions options)
   at Program.<Main>$(String[] args) in /Users/rad/Projects/BlogCode/ImageSerialization/Program.cs:line 14
```

The simplest way is to create a data transfer object [DTO](https://en.wikipedia.org/wiki/Data_transfer_object) specifically for this purpose.

```c#
namespace ImageSerialization;

public sealed record MovieDTO
{
    public required string Title { get; init; }
    public required int Length { get; init; }
    public required DateOnly ReleaseDate { get; init; }
    public required byte[] PosterData { get; init; } = [];
}
```

Note here the new property `PosterData` that is a `byte` `array`. This is safely **portable**.

Then we load the DTO directly.

```c#
// Create our DTO
var movieDTO = new MovieDTO
{
    Title = "The Old Woman With The Knife",
    Length = 183,
    ReleaseDate = new DateOnly(2025, 5, 1),
    PosterData = await File.ReadAllBytesAsync("movie.jpeg")
};
```

This can now be **safely** serialized.

```c#
// Serialize for transfer
var json = JsonSerializer.Serialize(movieDTO);
```

We will simulate receiving this `JSON` in another system.

```c#
// Deserialize for processing (assume this is a different system)
var receivedDTO = JsonSerializer.Deserialize<MovieDTO>(json)!;

// Map to a movie
var movie = new Movie
{
    Title = receivedDTO.Title,
    Length = receivedDTO.Length,
    ReleaseDate = receivedDTO.ReleaseDate,
    Poster = Image.Load<Rgba32>(receivedDTO.PosterData)
};

// Use our movie here
Log.Information("The poster for {MovieTitle} measures {BoundsWidth} x  {BoundsHeight}",
    movie.Title, movie.Poster.Bounds.Width, movie.Poster.Bounds.Height);
```

If we run this code, it will print the following:

```plaintext
[21:40:19 INF] The poster for The Old Woman With The Knife measures 459 x  680
```

In this way, we can avoid **platform** and **serialization** complications.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-02-10%20-%20ImageSerialization).

Happy hacking!
