---
layout: post
title: Extending The Results Type For XML Serialization In C# & .NET
date: 2025-12-16 10:06:52 +0300
categories:
    - C#
    - .NET
    - ASP.NET
---

Our last post, "[Building A Helper For XML Generation In C# & .NET]({% post_url 2025-12-15-building-a-helper-for-xml-generation-in-c-net %})", looked at how to build a **generic helper class** that transparently **serializes** passed classes to `XML`.

In this post, we will look at how to use [extension members](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/extension-methods) to make it **simpler** and more **discoverable**.

The helper `class` looked like this:

```c#
using System.Text;
using System.Xml;
using System.Xml.Serialization;

public static class ResultEx
{
    public static async Task<IResult> Xml<T>(T value)
    {
        return Results.Text(await Serialize(value), "application/xml", Encoding.UTF8);
    }

    private static async Task<string> Serialize<T>(T value)
    {
        var serializer = new XmlSerializer(typeof(T));
        await using var ms = new MemoryStream();
        await using (var writer = XmlWriter.Create(
                         ms,
                         new XmlWriterSettings
                         {
                             Encoding = Encoding.UTF8,
                             Indent = true,
                             Async = true
                         }))
        {
            serializer.Serialize(writer, value);
        }

        return Encoding.UTF8.GetString(ms.ToArray());
    }
}
```

We can build on this by using [extension members](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/extension-methods) to extend the [Results](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.http.results?view=aspnetcore-10.0) type.

The new `class` looks like this:

```c#
using System.Net.Mime;
using System.Text;
using System.Xml;
using System.Xml.Serialization;

public static class ResultEx
{
    extension(Results)
    {
        public static async Task<IResult> Xml<T>(T value)
        {
            return Results.Text(await Serialize(value), MediaTypeNames.Text.Xml, Encoding.UTF8);
        }

        private static async Task<string> Serialize<T>(T value)
        {
            var serializer = new XmlSerializer(typeof(T));
            await using var ms = new MemoryStream();
            await using (var writer = XmlWriter.Create(
                             ms,
                             new XmlWriterSettings
                             {
                                 Encoding = Encoding.UTF8,
                                 Indent = true,
                                 Async = true
                             }))
            {
                serializer.Serialize(writer, value);
            }

            return Encoding.UTF8.GetString(ms.ToArray());
        }
    }
}
```

Here, we have created a **static extension method**, as we did in the post "[Creating Static Extension Methods In C# & .NET]({% post_url 2025-11-01-creating-static-extension-methods-in-c-net %})", to extend the `Result` class.

We can now do the following:

```c#
app.MapGet("/Generate", () =>
{
    var faker = new Faker<Person>().UseSeed(0)
        .RuleFor(person => person.FirstName, faker => faker.Person.FirstName)
        .RuleFor(person => person.Surname, faker => faker.Person.LastName)
        .RuleFor(person => person.Salary, faker => faker.Random.Decimal(10_000, 99_000));

    return Results.Xml(faker.Generate(5));
});
app.Run();
```

Here, we can see the `Results` class now has an `XML` method, to which we pass the class(es) to serialize.

### TLDR

**We can extend the `Results` class using extension members to add the capacity to serialize to XML.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-12-16%20-%20XML).

Happy hacking!
