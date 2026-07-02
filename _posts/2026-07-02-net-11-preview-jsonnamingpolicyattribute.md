---
layout: post
title: .NET 11 Preview - JsonNamingPolicyAttribute
date: 2026-07-02 00:19:07 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

When serializing `JSON`, you have the ability to specify the **casing** of the names of **properties** of the `type`.

For example, given the following `type`:

```c#
public sealed class Spy
{
    public string FirstName { get; init; }
    public string Surname { get; init; }
    public DateOnly DatOfBirth { get; init; }
}
```

We can serialize this using [snake case](https://en.wikipedia.org/wiki/Snake_case) as follows:

```c#
using System.Text.Json;

var spy = new Spy
{
    FirstName = "James",
    Surname = "Bond",
    DateOfBirth = new DateOnly(1950, 1, 1)
};

var options = new JsonSerializerOptions
{
    WriteIndented = true,
    PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
};

Console.WriteLine(JsonSerializer.Serialize(spy, options));
```

This will print the following:

```json
{
  "first_name": "James",
  "surname": "Bond",
  "date_of_birth": "1950-01-01"
}
```

Suppose, for whatever reason, you wanted **different** **casing** on each `attribute`.

Typically, you would solve this problem using a custom [JsonConverter](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.serialization.jsonconverter-1?view=net-11.0-pp).

However, in .NET 11, you can now solve this problem by decorating each property with a [JsonNamingPolicy](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonnamingpolicy?view=net-11.0-pp) [attribute](https://medium.com/@payton9609/attributes-in-c-cccb57a3f42b), specifying what you want, as follows:

```c#
public sealed class Spy
{
    [JsonNamingPolicy(JsonKnownNamingPolicy.SnakeCaseLower)]
    public required string FirstName { get; init; }

    [JsonNamingPolicy(JsonKnownNamingPolicy.CamelCase)]
    public required string Surname { get; init; }

    [JsonNamingPolicy(JsonKnownNamingPolicy.CamelCase)]
    public required DateOnly DateOfBirth { get; init; }
}
```

You can then **serialize** and view the `JSON` as follows:

```c#
var newSpy = new V2.Spy
{
    FirstName = "James",
    Surname = "Bond",
    DateOfBirth = new DateOnly(1950, 1, 1)
};

var newOptions = new JsonSerializerOptions
{
    WriteIndented = true,
};

Console.WriteLine(JsonSerializer.Serialize(newSpy, newOptions));
```

This will print the following:

```json
{
  "first_name": "James",
  "surname": "Bond",
  "dateOfBirth": "1950-01-01"
}
```

You can see here the each property has a **different casing**.

### TLDR

**You can specify the naming policy of each property in a type using the `JsonNamingPolicy` attribute.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-07-02%20-%20NamingPolicy).

Happy hacking!
