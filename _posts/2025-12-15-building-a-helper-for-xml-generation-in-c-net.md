---
layout: post
title: Building A Helper For XML Generation In C# & .NET
date: 2025-12-15 09:37:33 +0300
categories:
    - C#
    - . NET
    - ASP.NET
---

Our last post, "[Manually Generating XML Output in ASP.NET]({% post_url 2025-12-13-manually-generating-xml-output-in-aspnet %})", looked at how to manually generate `XML` payloads using [ASP.NET Minimal APIs](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/minimal-apis?view=aspnetcore-10.0), if you **cannot** or **do not want** to use a solution such as [Carter](https://github.com/CarterCommunity/Carter), or [controllers](https://learn.microsoft.com/en-us/aspnet/mvc/overview/older-versions-1/controllers-and-routing/aspnet-mvc-controllers-overview-cs).

Of interest is the following code:

```c#
var serializer = new XmlSerializer(typeof(List<Person>));
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
    serializer.Serialize(writer, faker.Generate(5));
}

ms.Position = 0;
await ms.CopyToAsync(ctx.Response.Body);
```

As a recap, this code serializes the data into a memory stream and then writes that to the response output stream.

This works fine, but it is tedious and repetitive to repeat the code in each endpoint.

We can refactor this into a generic helper class that will do the heavy lifting for us.

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

Here, our helper class has a method, `XML`, that returns an `IResult` that is a return type for an endpoint.

We can use our new helper class like this:

```c#
app.MapGet("/Generate", () =>
{
    var faker = new Faker<Person>().UseSeed(0)
        .RuleFor(person => person.FirstName, faker => faker.Person.FirstName)
        .RuleFor(person => person.Surname, faker => faker.Person.LastName)
        .RuleFor(person => person.Salary, faker => faker.Random.Decimal(10_000, 99_000));

    return ResultEx.Xml(faker.Generate(5));
});
```

Much simpler.

And now we can reuse this class to **serialize** any **serializable** class passed to it.

### TLDR

**We can write a helper class and method to handle serialization of any passed type.**

The code is in my GitHub.

Happy hacking!
